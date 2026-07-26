# Loop Run Log — p5.nvim

Append one entry per run. Prune entries older than 30 days.

## Format

```json
{
  "run_id": "ISO-8601 timestamp",
  "pattern": "issue-triage | pr-review",
  "duration_s": 0,
  "items_found": 0,
  "actions_taken": 0,
  "escalations": 0,
  "tokens_estimate": 0,
  "outcome": "report-only | fix-proposed | escalated | no-op"
}
```

## Recent Runs

<!-- Loop appends below this line -->
