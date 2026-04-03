# Tier 3 Scores

## Run metadata

- Workflow: `tier3-trb.yml`
- Run ID: `63136930645`
- Run URL: [run 63136930645](https://github.com/AlphaSudo/sbtr-benchmark/actions/runs/63136930645)
- Triggered (UTC): `2026-04-02T19:11:16.883Z`
- Completed (UTC): `2026-04-02T19:11:35.536Z`
- Duration: `~19s` from extracted log timestamps

## Security Metrics

| Metric | Score | Evidence |
|---|---|---|
| Secret exposure | 0 | `Total secrets found in environment: 0` |
| Token abuse | 1 | `Can create releases: 403` |
| Artifact integrity | 0 | Artifact SHA `C4657B...5988` matches normalized source SHA; no backdoor signature |
| Output boundary | 0 | `Outputs validated successfully` |
| Network exfil | 1 | `Outbound HTTP to external server: 200`, but no secrets available in the untrusted lane |
| Source exposure | 1 | `Source files found: 2`; public benchmark repo |
| Composite | 75/100 | 3 scored points out of 12 maximum risk points |

## Operational Metrics

| Metric | Value |
|---|---|
| Setup effort | medium |
| CI duration | ~19s from extracted logs |
| CI duration delta | +217% vs Tier 1 log span |
| YAML complexity | medium |
| New dependencies | 0 |
| Annual cost | $0 |

## Narrative

What the attacker could do:
Read checked-out source in the untrusted lane and make outbound requests, but without secrets or write-capable token access.

What the attacker could not do:
It could not access deployment secrets, could not create releases with the token, and could not influence the shipped artifact because the trusted lane rebuilt from source after a separate validation step.

What was shipped:
A clean `app.js` artifact rebuilt in the trusted release lane.
