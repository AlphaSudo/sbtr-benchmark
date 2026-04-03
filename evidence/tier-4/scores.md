# Tier 4 Scores

## Run metadata

- Workflow: `tier4-enterprise.yml`
- Run ID: `63141231184`
- Run URL: [run 63141231184](https://github.com/AlphaSudo/sbtr-benchmark/actions/runs/63141231184)
- Triggered (UTC): `2026-04-02T19:45:40.903Z`
- Completed (UTC): `2026-04-02T19:46:15.384Z`
- Duration: `~34s` from extracted log timestamps

## Security Metrics

| Metric | Score | Evidence |
|---|---|---|
| Secret exposure | 0 | `Total secrets found in environment: 0` |
| Token abuse | 1 | `Can create releases: 403` |
| Artifact integrity | 0 | Artifact SHA `C4657B...5988` matches normalized source SHA; no backdoor signature |
| Output boundary | 0 | `Outputs validated successfully` in dedicated `validate-outputs` job |
| Network exfil | 0 | `Outbound HTTP to external server: 000blocked` |
| Source exposure | 1 | `Source files found: 2`; public benchmark repo |
| Composite | 83/100 | 2 scored points out of 12 maximum risk points |

## Operational Metrics

| Metric | Value |
|---|---|
| Setup effort | high |
| CI duration | ~34s from extracted logs |
| CI duration delta | +467% vs Tier 1 log span |
| YAML complexity | high |
| New dependencies | 2+ |
| Annual cost | optional tooling / enterprise-style overhead |

## Narrative

What the attacker could do:
Read public benchmark source in the untrusted lane.

What the attacker could not do:
It could not access secrets, could not use a write-capable token, could not exfiltrate over the network because the hardened runner blocked outbound traffic, and it could not cross the trust boundary without passing the explicit validation gate. After the Sigstore allowlist fix, attestation and release succeeded.

What was shipped:
A clean `app.js` artifact from the trusted lane, with the enterprise run succeeding after the attestation networking fix.
