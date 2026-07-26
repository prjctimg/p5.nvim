# LOOP.md — p5.nvim

Neovim plugin for p5.js sketchspaces. Includes live server, package management, Gist sync, and CDP DevTools.

## Active Loops

### Issue Triage (L1 — report only)
- Cadence: 1d weekdays
- Skill: `loop-triage`
- State: STATE.md
- Phase: Report-only. L2 after trust established.
- Handoff: Design decisions, breaking changes, new feature scope.

### PR Review (L2 — assisted)
- Cadence: on PR creation
- Skill: `loop-triage` + `loop-verifier`
- State: STATE.md
- Phase: Assisted — verifier runs pytest + luacheck + stylua in worktree.
- Handoff: Anything touching server.py, plugin/, or core lua modules.

## Worktrees

- Use isolated git worktrees for any L2 code changes.
- One worktree per fix attempt; discard after verifier REJECT or escalation.

## Budget & Observability

- Token caps: `loop-budget.md`
- Run history: `loop-run-log.md`
- Kill switch: `loop-pause-all` label in STATE.md

## Safety

- Never auto-merge changes to `plugin/` or `server.py`.
- All Lua changes must pass luacheck + stylua.
- Python changes must pass pytest.
