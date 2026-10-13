#!/usr/bin/env bash
# Regenerate the <!-- CONTRIBUTORS --> block in README.md from git history.
#
# Canonical generator shared across all prjctimg projects. It maps the commit
# identities onto GitHub logins, filters automation accounts, and writes a
# single deterministic avatar row between the CONTRIBUTORS markers (creating
# the section before the license line when it is missing).
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${REPO_ROOT:-$(git -C "$script_dir" rev-parse --show-toplevel 2>/dev/null || git rev-parse --show-toplevel)}"
readme="${1:-$repo_root/README.md}"

# email -> github login (canonical identities)
declare -A EMAIL_MAP=(
	["prjctimg@outlook.com"]="prjctimg"
	["prjctimg@penguin"]="prjctimg"
	["arcaneqoder@gmail.com"]="prjctimg"
	["104896135+prjctimg@users.noreply.github.com"]="prjctimg"
	["iseeheaven@outlook.com"]="iseeheaven"
	["iseeheaven@users.noreply.github.com"]="iseeheaven"
	["xml-wizard@outlook.com"]="iseeheaven"
	["prjctimg@yandex.com"]="skchr"
	["vaishnav.sabari.girish@gmail.com"]="vaishnav-sabari-girish"
	["petingavasco@protonmail.com"]="Petingoso"
)

# name -> github login (fallback when the email is unknown)
declare -A NAME_MAP=(
	["Dean Tarisai"]="prjctimg"
	["ディーン・タリサイ"]="prjctimg"
	["prjctimg"]="prjctimg"
	["iseeheaven"]="iseeheaven"
	["skchr"]="skchr"
	["Vaishnav Sabari Girish"]="vaishnav-sabari-girish"
	["Petingoso"]="Petingoso"
)

is_bot() {
	local name="$1" email="$2"
	[[ "$name" == *"[bot]"* ]] && return 0
	case "$name" in
		github-actions* | gh-actions | "GitHub Action" | p5-docs-bot) return 0 ;;
		"Test" | "Test User" | test-user | CI | ci) return 0 ;;
	esac
	case "$email" in
		*github-actions* | actions@github.com | action@github.com | docs@p5js.org | *[Bb]ot@*) return 0 ;;
		*@example.com | *@example.org | *@example.net | *@localhost) return 0 ;;
	esac
	return 1
}

declare -A seen=()
contributors=()
while IFS='|' read -r name email; do
	[[ -z "${name}${email}" ]] && continue
	is_bot "$name" "$email" && continue
	login="${EMAIL_MAP[$email]:-}"
	[[ -z "$login" ]] && login="${NAME_MAP[$name]:-}"
	if [[ -z "$login" ]]; then
		login="$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
	fi
	[[ -z "$login" ]] && continue
	if [[ -z "${seen[$login]:-}" ]]; then
		seen[$login]=1
		contributors+=("$login")
	fi
done < <(git -C "$repo_root" log --format='%aN|%aE' | LC_ALL=C sort -u)

if [[ ${#contributors[@]} -eq 0 ]]; then
	echo "Error: no contributors after filtering" >&2
	exit 1
fi

mapfile -t ordered < <(printf '%s\n' "${contributors[@]}" | LC_ALL=C sort)

avatars=""
for user in "${ordered[@]}"; do
	avatars+="<a href=\"https://github.com/${user}\"><img src=\"https://github.com/${user}.png?size=80\" width=\"50\" height=\"50\" style=\"border-radius:50%;margin:4px;\" alt=\"${user}\"/></a> "
done
avatars="${avatars% }"

python3 - "$readme" "$avatars" <<'PY'
import pathlib, re, sys

readme, avatars = pathlib.Path(sys.argv[1]), sys.argv[2]
text = readme.read_text()
blk, end = "<!-- CONTRIBUTORS -->", "<!-- /CONTRIBUTORS -->"
section = "## Contributors\n\n" + blk + '\n<p align="left">\n  ' + avatars + "\n</p>\n" + end
pat = re.compile(
    r"\n*(?:## Contributors\n+)?" + re.escape(blk) + r".*?" + re.escape(end) + r"\n*",
    re.DOTALL,
)
if pat.search(text):
    text = pat.sub(lambda _m: "\n\n" + section + "\n\n", text, count=1)
    # Only collapse blank runs around the block we just wrote.
    head, sep, rest = text.partition(section)
    text = head + re.sub(r"\n{3,}", "\n\n", sep + rest)
else:
    patterns = [
        r"^#+\s*License.*$",
        r"^>\s*#+\s*License.*$",
        r"^>\s*\*\*License.*$",
        r"^\*\*License.*$",
        r"^>?\s*\(c\).*$",
    ]
    best = None
    for p in patterns:
        m = re.search(p, text, re.MULTILINE | re.IGNORECASE)
        if m and (best is None or m.start() < best):
            best = m.start()
    if best is not None:
        text = text[:best] + section + "\n\n" + text[best:]
    else:
        text = text.rstrip("\n") + "\n\n" + section + "\n"
if not text.endswith("\n"):
    text += "\n"
readme.write_text(text)
PY

echo "updated $readme with ${#ordered[@]} contributors: ${ordered[*]}"
