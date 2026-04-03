# Benchmark Comparison Table

Filled from the downloaded benchmark evidence on 2026-04-02. Operational fields that were not captured from the GitHub run summary are left as `not recorded` rather than estimated.

| Metric | Tier 1 | Tier 2 | Tier 3 | Tier 4 |
|---|---|---|---|---|
| Secret exposure | 2 | 2 | 0 | 0 |
| Token abuse | 2 | 1 | 1 | 1 |
| Artifact integrity | 2 | 2 | 0 | 0 |
| Output boundary | N/A | N/A | 0 | 0 |
| Network exfil | 2 | 2 | 1 | 0 |
| Source exposure | 1 | 1 | 1 | 1 |
| Composite | 10 | 20 | 75 | 83 |
| Setup effort | baseline | low | medium | high |
| CI duration | ~6s | ~8s | ~19s | ~34s |
| Annual cost | $0 | $0 | $0 | optional tooling / enterprise-style overhead |

## Notes

- Tier 1 evidence shows `Can create releases: 201`, `Total secrets found in environment: 3`, outbound HTTP `200`, and a poisoned artifact with a detected backdoor signature.
- Tier 2 evidence shows `Can create releases: 403`, but still exposes `3` secrets, allows outbound HTTP `200`, and ships a poisoned artifact.
- Tier 3 evidence shows `Total secrets found in environment: 0`, `Can create releases: 403`, `Outputs validated successfully`, and a clean rebuilt artifact. Network remained open, so it scores `1` on exfiltration risk.
- Tier 4 evidence now shows `Total secrets found in environment: 0`, outbound HTTP `000blocked`, `Outputs validated successfully`, a clean artifact, and a successful release after allowing Sigstore endpoints for attestation.
- `Source exposure` is capped at `1` across tiers because this benchmark repo is public.
