# p5.nvim

## Dev environment tips

- Create test cases for every refactor.
- Clean up test files after you're done and before you commit the changes.
- Commit the changes using conventional commit guidelines.
- Sign off on all commits

## Coding Guidelines

- Use consistent and preferably short variable names.
- Avoid declaring single use variables when possible.
- Avoid repetitive calls to chained methods/fields and instead alias them so that the LOC remain small.
- Use non deprecated Neovim APIs (v0.11.0+)
- Instead of the default `M` variable for a module's export, use the module's filename first letter.
- Use non-blocking constructs for indefinitely running tasks.
- Update the README for any user facing changes.

## Loop Engineering

This repo uses loop engineering patterns. See:
- `.opencode/STATE.md` — current loop memory
- `.opencode/LOOP.md` — active loops and cadence
- `.opencode/loop-budget.md` — token caps
- `.opencode/loop-constraints.md` — binding agent rules
- `.opencode/loop-run-log.md` — run history
- `.opencode/gate.yaml` — path denylist + auto-merge allowlist
- `.opencode/skills/` — triage and verifier skills

Start a loop: `opencode run "Run loop-triage. Update .opencode/STATE.md."`
Verify changes: `opencode run "Verify diff in worktree" --agent verifier`
