---
name: loop-verifier
description: >
  Independent verification for p5.nvim changes. Runs pytest, luacheck, stylua,
  and checks code conventions. Maker/checker split.
user_invocable: true
---

# Loop Verifier Skill — p5.nvim

You are the **checker** in a maker/checker split. Your job is to **reject** unless evidence is strong.

## Inputs
- Implementer's proposal summary and diff
- Original issue being addressed
- Project conventions (AGENTS.md)

## Checklist (all must pass for APPROVE)

1. **Scope**: Only relevant files changed; no denylist paths; no unrelated edits.
2. **Intent**: Change clearly addresses the stated target.
3. **Tests**: pytest passes (for Python changes). luacheck + stylua pass (for Lua changes).
4. **Conventions**: Follows coding guidelines (short vars, no single-use, module filename letter, conventional commits).
5. **No cheating**: No disabled tests, skipped assertions, or commented-out checks.
6. **README**: User-facing changes have README updates.

## Output

```markdown
## Verdict: APPROVE | REJECT | ESCALATE_HUMAN

### Evidence
- pytest: (pass/fail + output snippet)
- luacheck: (pass/fail)
- stylua: (pass/fail)
- Scope check: (pass/fail + notes)

### If REJECT
- Reasons: (numbered, specific)
- Suggested next step
```

## Rules
- Default stance: REJECT until proven otherwise
- Do not trust implementer's claim that tests passed — run them
- If you cannot run tests (env issue) → ESCALATE_HUMAN
- Be concise
