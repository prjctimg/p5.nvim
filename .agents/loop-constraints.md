# Loop Constraints — p5.nvim

> The `loop-triage` and `loop-verifier` skills read this file at the start of every run.
> Constraints here are **binding** — the agent MUST follow them.

## Push & Merge
- Never auto-merge to main without human approval
- Always create a draft PR first
- Sign off on all commits

## Paths
- Never edit `.git/` or hidden config files
- Never auto-edit `plugin/` or `server.py` — flag for human review
- Never edit `tests/` without also creating/updating test cases

## Code
- Create test cases for every refactor
- Clean up test files before commit
- Use conventional commit guidelines
- Use consistent and preferably short variable names
- Avoid declaring single use variables when possible
- Avoid repetitive calls to chained methods/fields — alias them
- Use non-deprecated Neovim APIs (v0.11.0+)
- Use module filename first letter instead of default `M` variable
- Use non-blocking constructs for indefinitely running tasks
- Update README for any user-facing changes

## Communication
- Always tell the user what you're about to do before doing it
- Never close an issue or PR without approval

## Budget
- If token spend hits 80% of daily cap, switch to report-only
- If loop-pause-all is active, exit immediately
