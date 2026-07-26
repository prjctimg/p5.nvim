# Loop Budget — p5.nvim

## Daily limits

| Loop | Max runs/day | Max tokens/day | Max sub-agent spawns/run |
|------|--------------|----------------|--------------------------|
| Issue Triage | 1 | 50k | 0 (L1) |
| PR Review | 4 | 150k | 1 (L2 verifier) |

## On budget exceed

1. Pause schedulers
2. Append event to `loop-run-log.md`
3. Open maintainer issue

## Kill switch

- Label: `loop-pause-all`
- Resume only after cleared in STATE.md
