#!/usr/bin/env python3
"""Weekly "what changed" report generator.

Scans the commits in a time window and reports changes to a project's
important surface:

  * public API changes (added / removed / modified signatures)
  * language, edition and toolchain changes
  * dependency changes (added / removed / bumped, with major-bump flags)

and emits Markdown containing the findings, potential issues, and a
verification checklist addressed to another agent. The report always goes
to stdout and optionally to ``--out``; a machine-readable JSON payload is
embedded in an HTML comment for downstream tooling.

The script is intentionally dependency-free (stdlib only) and never fails
the caller: exit status is always 0. When nothing important changed it
writes a single ``<!-- what-changed: empty -->`` sentinel so the workflow
can skip opening an issue.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

# ---------------------------------------------------------------------------
# git plumbing
# ---------------------------------------------------------------------------


def git(repo: str, *args: str, check: bool = True) -> str:
    res = subprocess.run(
        ["git", "-C", repo, *args],
        capture_output=True,
        text=True,
        check=False,
    )
    if check and res.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)} failed: {res.stderr.strip()}")
    return res.stdout


def git_show(repo: str, rev: str, path: str) -> str:
    return git(repo, "show", f"{rev}:{path}", check=False)


# ---------------------------------------------------------------------------
# file classification
# ---------------------------------------------------------------------------

LANG_BY_EXT = {
    ".rs": "rust",
    ".ts": "typescript",
    ".tsx": "typescript",
    ".mts": "typescript",
    ".cts": "typescript",
    ".js": "javascript",
    ".jsx": "javascript",
    ".mjs": "javascript",
    ".cjs": "javascript",
    ".py": "python",
    ".lua": "lua",
    ".go": "go",
    ".rb": "ruby",
    ".java": "java",
    ".c": "c",
    ".h": "c",
    ".cc": "cpp",
    ".cpp": "cpp",
    ".hpp": "cpp",
    ".nix": "nix",
    ".sh": "shell",
}

MANIFESTS = {
    "package.json",
    "cargo.toml",
    "cargo.lock",
    "go.mod",
    "go.sum",
    "pyproject.toml",
    "pipfile",
    "gemfile",
    "composer.json",
    "build.gradle",
    "pom.xml",
}
LOCKFILES = {
    "cargo.lock",
    "package-lock.json",
    "pnpm-lock.yaml",
    "yarn.lock",
    "bun.lockb",
    "bun.lock",
    "poetry.lock",
    "uv.lock",
    "gemfile.lock",
    "go.sum",
}
TOOLCHAIN_FILES = {
    "rust-toolchain",
    "rust-toolchain.toml",
    ".nvmrc",
    ".node-version",
    ".python-version",
    ".tool-versions",
    "flake.nix",
    "flake.lock",
    "tsconfig.json",
    "deno.json",
    "deno.jsonc",
}

API_PATTERNS = {
    "rust": [
        re.compile(
            r"^\s*pub(?:\([^)]*\))?\s+(?:async\s+)?(?:unsafe\s+)?"
            r"(fn|struct|enum|trait|type|const|static|mod|union)\s+([A-Za-z_]\w*)"
        ),
        re.compile(r"^\s*pub\s+use\s+([^;]+)"),
    ],
    "typescript": [
        re.compile(
            r"^\s*export\s+(?:default\s+)?(?:async\s+)?"
            r"(function|class|const|let|var|interface|type|enum)\s+([A-Za-z_$][\w$]*)"
        ),
        re.compile(r"^\s*export\s+default\s+([A-Za-z_$][\w$]*)"),
        re.compile(r"^\s*export\s*\{\s*([^}]+)\}"),
    ],
    "javascript": [
        re.compile(
            r"^\s*(?:export\s+)?(?:async\s+)?"
            r"(function|class)\s+([A-Za-z_$][\w$]*)"
        ),
        re.compile(r"^\s*module\.exports\s*=\s*([A-Za-z_$][\w$]*)"),
    ],
    "python": [
        re.compile(r"^\s*(?:async\s+)?def\s+([A-Za-z_]\w*)"),
        re.compile(r"^\s*class\s+([A-Za-z_]\w*)"),
    ],
    "lua": [
        re.compile(r"^\s*function\s+([A-Za-z_]\w*[.:][\w.:]+)"),
        re.compile(r"^\s*([A-Z]\w*)\.(\w+)\s*=\s*function"),
        re.compile(r"^\s*function\s+([A-Z]\w*)\b"),
    ],
    "go": [
        re.compile(r"^\s*func\s+(?:\([^)]*\)\s*)?([A-Z]\w*)"),
        re.compile(r"^\s*type\s+([A-Z]\w*)\s+(?:struct|interface)"),
    ],
    "ruby": [
        re.compile(r"^\s*def\s+(?:self\.)?([A-Za-z_]\w*[!?=]?)"),
        re.compile(r"^\s*(?:class|module)\s+([A-Z]\w*)"),
    ],
}


def classify(path: str) -> str:
    name = os.path.basename(path).lower()
    ext = os.path.splitext(path)[1].lower()
    if name in LOCKFILES:
        return "lockfile"
    if name in MANIFESTS:
        return "manifest"
    if name in TOOLCHAIN_FILES or name.startswith("tsconfig"):
        return "toolchain"
    if path.startswith(".github/workflows/") and ext in (".yml", ".yaml"):
        return "ci"
    return LANG_BY_EXT.get(ext, "other")


def parse_api(lang: str, lines: list[str]) -> list[str]:
    out: list[str] = []
    for line in lines:
        for pat in API_PATTERNS.get(lang, []):
            m = pat.match(line)
            if not m:
                continue
            if m.re.groups >= 2:
                out.append(f"{m.group(1)} {m.group(2)}")
            else:
                out.append(m.group(1).strip())
            break
    return out


# ---------------------------------------------------------------------------
# dependency / toolchain extraction
# ---------------------------------------------------------------------------


def dep_diff_json(repo: str, base: str, head: str, path: str) -> dict:
    """Structural dependency diff for package.json-like files."""
    try:
        before = json.loads(git_show(repo, base, path) or "{}")
        after = json.loads(git_show(repo, head, path) or "{}")
    except json.JSONDecodeError:
        return {}
    result: dict[str, dict[str, list]] = {}
    for section in (
        "dependencies",
        "devDependencies",
        "peerDependencies",
        "optionalDependencies",
    ):
        a = before.get(section, {}) or {}
        b = after.get(section, {}) or {}
        added = {k: v for k, v in b.items() if k not in a}
        removed = {k: v for k, v in a.items() if k not in b}
        bumped = {k: (a[k], b[k]) for k in a if k in b and a[k] != b[k]}
        if added or removed or bumped:
            result[section] = {"added": added, "removed": removed, "bumped": bumped}
    tool = {}
    for key in ("engines", "packageManager"):
        a, b = before.get(key), after.get(key)
        if a != b:
            tool[key] = {"from": a, "to": b}
    if tool:
        result["__toolchain__"] = tool
    return result


def _cargo_deps(text: str) -> dict[str, str]:
    deps: dict[str, str] = {}
    section = ""
    for line in text.splitlines():
        s = line.strip()
        m = re.match(r"^\[([^\]]+)\]", s)
        if m:
            section = m.group(1)
            continue
        if not section.endswith("dependencies"):
            continue
        m = re.match(r'^([A-Za-z0-9_-]+)\s*=\s*(.+)$', s)
        if m:
            deps[m.group(1)] = m.group(2).rstrip(",")
    return deps


def dep_diff_cargo(repo: str, base: str, head: str, path: str) -> dict:
    before = _cargo_deps(git_show(repo, base, path))
    after = _cargo_deps(git_show(repo, head, path))
    added = {k: v for k, v in after.items() if k not in before}
    removed = {k: v for k, v in before.items() if k not in after}
    bumped = {k: (before[k], after[k]) for k in before if k in after and before[k] != after[k]}
    out: dict[str, dict] = {}
    if added or removed or bumped:
        out["cargo"] = {"added": added, "removed": removed, "bumped": bumped}
    return out


def dep_diff_toml_like(repo: str, base: str, head: str, path: str) -> dict:
    """Line-oriented dependency diff for pyproject/requirements/go.mod."""
    before = git_show(repo, base, path).splitlines()
    after = git_show(repo, head, path).splitlines()
    dep_re = re.compile(
        r'(?:^|\s)([A-Za-z0-9_.\-]+)\s*(?:=|>=|==|~=|\^)\s*[\"\']?([\w.*\-+]+)'
    )

    def deps(lines):
        d = {}
        for line in lines:
            m = dep_re.search(line)
            if m:
                d[m.group(1)] = m.group(2)
        return d

    a, b = deps(before), deps(after)
    added = {k: v for k, v in b.items() if k not in a}
    removed = {k: v for k, v in a.items() if k not in b}
    bumped = {k: (a[k], b[k]) for k in a if k in b and a[k] != b[k]}
    if added or removed or bumped:
        return {"deps": {"added": added, "removed": removed, "bumped": bumped}}
    return {}


def changed_ci_actions(repo: str, base: str, head: str, path: str) -> list[str]:
    added, removed = diff_pairs(repo, base, head, path)
    pat = re.compile(r"uses:\s*([\w.-]+/[\w.-]+)@(\S+)")
    out: list[str] = []
    for line in added:
        m = pat.search(line)
        if m:
            out.append(f"{m.group(1)} -> {m.group(2)}")
    for line in removed:
        m = pat.search(line)
        if m:
            out.append(f"{m.group(1)} <- {m.group(2)}")
    return out


def toolchain_values(path: str, text: str) -> dict:
    name = os.path.basename(path).lower()
    values: dict[str, str] = {}
    if name == "cargo.toml":
        for key in ("edition", "rust-version", "version"):
            m = re.search(rf'^\s*{re.escape(key)}\s*=\s*"?([^"\n]+)"?', text, re.M)
            if m:
                values[key] = m.group(1).strip()
    elif name.endswith("tsconfig.json"):
        try:
            data = json.loads(re.sub(r"//.*", "", text))
        except json.JSONDecodeError:
            data = {}
        for key in ("target", "lib", "module", "moduleResolution", "types", "strict"):
            if key in data:
                values[key] = json.dumps(data[key])
    elif name == "go.mod":
        m = re.search(r"^go\s+([\d.]+)", text, re.M)
        if m:
            values["go"] = m.group(1)
    elif name in (".nvmrc", ".node-version", ".python-version", "rust-toolchain"):
        v = text.strip()
        if v:
            values[name] = v
    elif name == "flake.nix":
        m = re.search(r"nixpkgs[^\n]*url\s*=\s*\"([^\"]+)\"", text)
        if m:
            values["nixpkgs"] = m.group(1)
    elif name.startswith(("requirements", "pyproject")) or name == "pipfile":
        m = re.search(r'python_requires\s*=\s*"([^"]+)"', text) or re.search(
            r"requires-python\s*=\s*\"([^\"]+)\"", text
        )
        if m:
            values["requires-python"] = m.group(1)
    return values


# ---------------------------------------------------------------------------
# diff helpers
# ---------------------------------------------------------------------------


def diff_lines(repo: str, base: str, head: str, path: str) -> tuple[list[str], list[str]]:
    raw = git(repo, "diff", "-U0", f"{base}..{head}", "--", path, check=False)
    added, removed = [], []
    for line in raw.splitlines():
        if line.startswith("+++") or line.startswith("---"):
            continue
        if line.startswith("+"):
            added.append(line[1:])
        elif line.startswith("-"):
            removed.append(line[1:])
    return added, removed


def diff_pairs(repo: str, base: str, head: str, path: str) -> tuple[list[str], list[str]]:
    return diff_lines(repo, base, head, path)


def major(version: str) -> str:
    m = re.search(r"(\d+)", version or "")
    return m.group(1) if m else ""


# ---------------------------------------------------------------------------
# report assembly
# ---------------------------------------------------------------------------


def build_report(repo: str, base: str, head: str) -> tuple[str, bool]:
    name_status = git(repo, "diff", "--name-status", f"{base}..{head}", check=False)
    files: list[tuple[str, str]] = []
    for line in name_status.splitlines():
        parts = line.split("\t")
        if len(parts) >= 2:
            files.append((parts[0], parts[-1]))

    api_added: dict[str, list[str]] = {}
    api_removed: dict[str, list[str]] = {}
    api_modified: list[str] = []
    deps: dict[str, dict] = {}
    toolchain: dict[str, tuple[dict, dict]] = {}
    ci_actions: list[str] = []
    lockfiles: list[str] = []
    touched_kinds: dict[str, int] = {}

    for status, path in files:
        kind = classify(path)
        touched_kinds[kind] = touched_kinds.get(kind, 0) + 1

        if kind in ("rust", "typescript", "javascript", "python", "lua", "go", "ruby"):
            added, removed = diff_lines(repo, base, head, path)
            a_ids = parse_api(kind, added)
            r_ids = parse_api(kind, removed)
            if a_ids:
                api_added.setdefault(kind, []).extend(a_ids)
            if r_ids:
                api_removed.setdefault(kind, []).extend(r_ids)
            a_set, r_set = set(a_ids), set(r_ids)
            for sig in sorted(r_set - a_set):
                ident = sig.split()[-1]
                if any(ident == s.split()[-1] for s in a_set):
                    api_modified.append(f"`{sig}` (signature changed)")
        elif kind == "manifest":
            lname = os.path.basename(path).lower()
            if lname == "package.json":
                deps.update(dep_diff_json(repo, base, head, path))
            elif lname == "cargo.toml":
                deps.update(dep_diff_cargo(repo, base, head, path))
            elif lname in ("go.mod", "pyproject.toml", "pipfile") or lname.startswith(
                "requirements"
            ):
                deps.update(dep_diff_toml_like(repo, base, head, path))
        elif kind == "toolchain":
            before = toolchain_values(path, git_show(repo, base, path))
            after = toolchain_values(path, git_show(repo, head, path))
            if before != after:
                toolchain[path] = (before, after)
        elif kind == "ci":
            ci_actions.extend(f"{path}: {a}" for a in changed_ci_actions(repo, base, head, path))
        elif kind == "lockfile":
            lockfiles.append(path)

    # flatten package.json-style deps into uniform buckets
    flat_added: list[str] = []
    flat_removed: list[str] = []
    flat_bumped: list[tuple[str, str, str]] = []
    for section, data in deps.items():
        if section == "__toolchain__":
            for key, val in data.items():
                toolchain[f"package.json#{key}"] = (
                    {key: val.get("from")},
                    {key: val.get("to")},
                )
            continue
        for k, v in data.get("added", {}).items():
            flat_added.append(f"[{section}] {k} {v}")
        for k, v in data.get("removed", {}).items():
            flat_removed.append(f"[{section}] {k} {v}")
        for k, (a, b) in data.get("bumped", {}).items():
            flat_bumped.append((f"[{section}] {k}", a, b))

    n_api = sum(len(v) for v in api_added.values()) + sum(
        len(v) for v in api_removed.values()
    ) + len(api_modified)
    significant = bool(
        n_api or flat_added or flat_removed or flat_bumped or toolchain or ci_actions
    )

    repo_name = os.path.basename(os.path.normpath(repo))
    date = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    n_commits = git(repo, "rev-list", "--count", f"{base}..{head}", check=False).strip()

    lines: list[str] = []
    lines.append(f"# What changed — `{repo_name}` — week of {date}")
    lines.append("")
    lines.append(f"Window: `{base[:10]}..{head[:10]}` — {n_commits} commit(s).")
    lines.append("")

    if not significant:
        lines.append("No changes to public APIs, language/toolchain settings or dependencies.")
        lines.append("")
        lines.append("<!-- what-changed: empty -->")
        return "\n".join(lines), False

    lines.append("## Summary")
    lines.append("")
    lines.append(f"- Public API changes: **{n_api}**")
    lines.append(f"- Dependency changes: **{len(flat_added) + len(flat_removed) + len(flat_bumped)}**")
    lines.append(f"- Language / toolchain changes: **{len(toolchain)}**")
    lines.append(f"- CI action bumps: **{len(ci_actions)}**")
    lines.append(f"- Files touched: **{len(files)}** ({', '.join(f'{k}:{v}' for k, v in sorted(touched_kinds.items()))})")
    lines.append("")

    if n_api or api_modified:
        lines.append("## API changes")
        lines.append("")
        for kind, items in sorted(api_added.items()):
            lines.append(f"### Added — {kind}")
            lines.append("")
            for it in sorted(set(items)):
                lines.append(f"- `{it}`")
            lines.append("")
        for kind, items in sorted(api_removed.items()):
            lines.append(f"### Removed / changed — {kind}")
            lines.append("")
            for it in sorted(set(items)):
                lines.append(f"- `{it}`")
            lines.append("")
        if api_modified:
            lines.append("### Signature changes")
            lines.append("")
            for it in sorted(set(api_modified)):
                lines.append(f"- {it}")
            lines.append("")

    if toolchain:
        lines.append("## Language / toolchain")
        lines.append("")
        for path, (before, after) in sorted(toolchain.items()):
            keys = sorted(set(before) | set(after))
            for key in keys:
                b, a = before.get(key), after.get(key)
                if b != a:
                    lines.append(f"- `{path}` — **{key}**: `{b}` -> `{a}`")
        lines.append("")

    if flat_added or flat_removed or flat_bumped:
        lines.append("## Dependencies")
        lines.append("")
        if flat_added:
            lines.append("### Added")
            lines.append("")
            for it in sorted(set(flat_added)):
                lines.append(f"- `{it}`")
            lines.append("")
        if flat_removed:
            lines.append("### Removed")
            lines.append("")
            for it in sorted(set(flat_removed)):
                lines.append(f"- `{it}`")
            lines.append("")
        if flat_bumped:
            lines.append("### Bumped")
            lines.append("")
            for dep, a, b in sorted(set(flat_bumped)):
                flag = " ⚠️ **major**" if major(a) != major(b) else ""
                lines.append(f"- `{dep}`: `{a}` -> `{b}`{flag}")
            lines.append("")

    if ci_actions:
        lines.append("## CI actions")
        lines.append("")
        for it in sorted(set(ci_actions)):
            lines.append(f"- `{it}`")
        lines.append("")

    if lockfiles:
        lines.append("## Lockfiles")
        lines.append("")
        for it in sorted(set(lockfiles)):
            lines.append(f"- `{it}`")
        lines.append("")

    # ---- potential issues -------------------------------------------------
    issues: list[str] = []
    for kind, items in sorted(api_removed.items()):
        for it in sorted(set(items)):
            issues.append(
                f"Removed/renamed public {kind} API `{it}` — potential **breaking change**; "
                "confirm callers and tests were updated."
            )
    for it in sorted(set(api_modified)):
        issues.append(f"Changed public API signature {it} — verify compatibility.")
    for dep, a, b in sorted(set(flat_bumped)):
        if major(a) != major(b):
            issues.append(
                f"**Major** dependency bump `{dep}` (`{a}` -> `{b}`) — review the upstream "
                "changelog for breaking changes."
            )
    for path, (before, after) in sorted(toolchain.items()):
        for key in sorted(set(before) | set(after)):
            if before.get(key) != after.get(key):
                issues.append(
                    f"Toolchain change `{path}` **{key}** `{before.get(key)}` -> "
                    f"`{after.get(key)}` — check CI matrix, dev setup docs and minimum versions."
                )
    if ci_actions:
        issues.append("CI action versions changed — confirm the new versions still run on this repo.")
    if flat_added:
        issues.append(
            f"{len(set(flat_added))} new dependency/ies added — confirm they are intended, "
            "licensed acceptably, and reflected in the lockfile."
        )

    lines.append("## Potential issues")
    lines.append("")
    if issues:
        for it in issues:
            lines.append(f"- ⚠️ {it}")
    else:
        lines.append("- None detected by the heuristics; still verify the API additions above.")
    lines.append("")

    # ---- verification instructions for another agent ----------------------
    test_cmd = detect_test_command(repo)
    lines.append("## Verification instructions (for the reviewing agent)")
    lines.append("")
    lines.append(
        "Reproduce the diff and confirm each finding. Treat every item below as a claim "
        "to verify, not a fact."
    )
    lines.append("")
    lines.append("```sh")
    lines.append(f"git diff {base}..{head}")
    if test_cmd:
        lines.append(test_cmd)
    lines.append("```")
    lines.append("")
    lines.append("Checklist:")
    lines.append("")
    lines.append(
        "- [ ] Every **removed/renamed public API** is intentional and all call sites "
        "(including examples and docs) were updated."
    )
    lines.append(
        "- [ ] Every **added public API** has a docstring/doc entry and at least one test."
    )
    lines.append(
        "- [ ] Every **major dependency bump** is reconciled with the lockfile and the "
        "upstream breaking-change list."
    )
    lines.append(
        "- [ ] **Toolchain/engine** bumps are reflected in CI, `README` requirements and "
        "any `rust-toolchain`/`.nvmrc`/`requires-python` pins."
    )
    lines.append(
        "- [ ] The project still builds and the test suite passes on the new toolchain/deps."
    )
    lines.append("- [ ] Mark each of the above as CONFIRMED / FALSE-POSITIVE / NEEDS-HUMAN.")
    lines.append("")

    payload = {
        "repo": repo_name,
        "window": {"base": base, "head": head, "commits": int(n_commits or 0)},
        "api": {
            "added": {k: sorted(set(v)) for k, v in api_added.items()},
            "removed": {k: sorted(set(v)) for k, v in api_removed.items()},
            "modified": sorted(set(api_modified)),
        },
        "dependencies": {
            "added": sorted(set(flat_added)),
            "removed": sorted(set(flat_removed)),
            "bumped": sorted(f"{d}: {a} -> {b}" for d, a, b in set(flat_bumped)),
        },
        "toolchain": {k: [v[0], v[1]] for k, v in toolchain.items()},
        "ci_actions": sorted(set(ci_actions)),
        "issues": issues,
    }
    lines.append(f"<!-- what-changed: {json.dumps(payload, sort_keys=True)} -->")
    return "\n".join(lines), True


def detect_test_command(repo: str) -> str:
    pkg = Path(repo) / "package.json"
    if pkg.exists():
        try:
            data = json.loads(pkg.read_text())
            scripts = data.get("scripts", {})
            for key in ("test", "lint"):
                if key in scripts:
                    return f"npm run {key}   # or pnpm/yarn/bun run {key}"
        except json.JSONDecodeError:
            pass
    if (Path(repo) / "Cargo.toml").exists():
        return "cargo test --all"
    if (Path(repo) / "go.mod").exists():
        return "go test ./..."
    for marker in ("pytest.ini", "tox.ini", "setup.cfg"):
        if (Path(repo) / marker).exists():
            return "python -m pytest"
    if (Path(repo) / "Makefile").exists():
        return "make test   # if a test target exists"
    return ""


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------


def main() -> int:
    ap = argparse.ArgumentParser(description="Weekly what-changed report.")
    ap.add_argument("--repo", default=".", help="repository path (default: .)")
    ap.add_argument("--since", default="7 days ago", help="window start (git date)")
    ap.add_argument("--base", default="", help="explicit base revision")
    ap.add_argument("--head", default="HEAD", help="head revision (default: HEAD)")
    ap.add_argument("--out", default="", help="also write the report to this path")
    args = ap.parse_args()

    repo = os.path.abspath(args.repo)
    head = git(repo, "rev-parse", args.head).strip()

    if args.base:
        base = git(repo, "rev-parse", args.base).strip()
    else:
        base = git(repo, "rev-list", "-1", f"--before={args.since}", head, check=False).strip()
        if not base:
            base = git(repo, "rev-list", "--max-parents=0", head, check=False).strip().split("\n")[-1]

    if not base or base == head:
        report, has = "<!-- what-changed: empty -->\n", False
    else:
        report, has = build_report(repo, base, head)

    if args.out:
        Path(args.out).write_text(report + "\n")

    gh_output = os.environ.get("GITHUB_OUTPUT")
    if gh_output:
        with open(gh_output, "a") as fh:
            fh.write(f"has_changes={'true' if has else 'false'}\n")
            fh.write(f"base={base}\n")
            fh.write(f"head={head}\n")

    sys.stdout.write(report + "\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
