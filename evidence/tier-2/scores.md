# Tier 2 Scores

## Run metadata

- Workflow: `tier2-sha-pinned.yml`
- Run ID: `63136596234`
- Run URL: [run 63136596234](https://github.com/AlphaSudo/sbtr-benchmark/actions/runs/63136596234)
- Triggered (UTC): `2026-04-02T19:08:36.019Z`
- Completed (UTC): `2026-04-02T19:08:43.567Z`
- Duration: `~8s` from extracted log timestamps

## Security Metrics

| Metric | Score | Evidence |
|---|---|---|
| Secret exposure | 2 | `Total secrets found in environment: 3` |
| Token abuse | 1 | `Can create releases: 403` |
| Artifact integrity | 2 | Artifact SHA `C10EFF...A6CC`; backdoor signature detected |
| Output boundary | N/A | Single-job workflow with no cross-job trust boundary |
| Network exfil | 2 | `Outbound HTTP to external server: 200` with encoded payload present |
| Source exposure | 1 | `Source files found: 2`; public benchmark repo |
| Composite | 20/100 | 10 scored points out of 12 maximum risk points |

## Operational Metrics

| Metric | Value |
|---|---|
| Setup effort | low |
| CI duration | ~8s from extracted logs |
| CI duration delta | +33% vs Tier 1 log span |
| YAML complexity | low |
| New dependencies | 0 |
| Annual cost | $0 |

## Narrative

What the attacker could do:
Still access same-job secrets, exfiltrate data, and poison the final artifact.

What the attacker could not do:
The token could not create releases or use obvious write operations because workflow permissions were scoped down.

What was shipped:
A poisoned `app.js` artifact even though the workflow used a pinned checkout action and read-only contents permission.
