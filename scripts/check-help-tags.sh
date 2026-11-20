#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

fail=0

echo "Checking help docs..."

# 1) doc/tags must not be tracked
if git ls-files --error-unmatch doc/tags >/dev/null 2>&1; then
  echo "ERROR: doc/tags is tracked in git; remove it and keep it gitignored." >&2
  fail=1
fi

# 2) no duplicate help tags in doc/*.txt
if ! python3 - <<'PY'
import glob, re, collections, sys
tags = collections.defaultdict(list)
for path in sorted(glob.glob('doc/*.txt')):
    with open(path, 'r', errors='ignore') as f:
        for i,line in enumerate(f,1):
            for m in re.finditer(r'\*([^\s*][^*]*?)\*', line):
                tags[m.group(1)].append(f"{path}:{i}")
dups = {t:locs for t,locs in tags.items() if len(locs)>1}
if dups:
    print(f"ERROR: found {len(dups)} duplicate help tag(s):", file=sys.stderr)
    for t,locs in sorted(dups.items()):
        print(f"  {t}: " + ", ".join(locs), file=sys.stderr)
    sys.exit(1)
print("No duplicate help tags found.")
PY
then
  fail=1
fi

# 3) helptags generation must succeed
if command -v nvim >/dev/null 2>&1; then
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  cp -R doc "$tmp/doc"
  nvim --headless --clean -u NONE -c "helptags $tmp/doc" -c 'qa!' >/dev/null 2>&1
  echo "helptags generation succeeded."
else
  echo "nvim not found; skipping helptags generation check."
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

echo "Help checks passed."
