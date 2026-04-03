# Tier 1 Scores

## Run metadata

- Workflow: `tier1-no-security.yml`
- Run ID: `63136433313`
- Run URL: [run 63136433313](https://github.com/AlphaSudo/sbtr-benchmark/actions/runs/63136433313)
- Triggered (UTC): `2026-04-02T19:07:17.914Z`
- Completed (UTC): `2026-04-02T19:07:24.375Z`
- Duration: `~6s` from extracted log timestamps

## Security Metrics

| Metric | Score | Evidence |
|---|---|---|
| Secret exposure | 2 | `Total secrets found in environment: 3` |
| Token abuse | 2 | `Can create releases: 201` |
| Artifact integrity | 2 | Artifact SHA `C10EFF...A6CC`; backdoor signature detected |
| Output boundary | N/A | Single-job workflow with no cross-job trust boundary |
| Network exfil | 2 | `Outbound HTTP to external server: 200` with encoded payload present |
| Source exposure | 1 | `Source files found: 2`; public benchmark repo |
| Composite | 10/100 | 11 scored points out of 12 maximum risk points |

## Operational Metrics

| Metric | Value |
|---|---|
| Setup effort | baseline |
| CI duration | ~6s from extracted logs |
| CI duration delta | baseline |
| YAML complexity | low |
| New dependencies | 0 |
| Annual cost | $0 |

## Narrative

What the attacker could do:
Read secrets from the same job environment, create releases with the workflow token, exfiltrate over the network, and poison the shipped artifact.

What the attacker could not do:
Nothing meaningful blocked the malicious action in this tier.

What was shipped:
A poisoned `app.js` artifact containing a backdoor marker.
