# Anomaly Review

This review compares the actual benchmark outcomes against the pre-registered expectations in [expected-results.md](/C:/Java%20Developer/TRB/expected-results.md).

## Result

No scoring anomalies were observed in the final benchmark runs.

All recorded metric scores matched the pre-registered expectations:

- Tier 1 matched expected scores on secret exposure, token abuse, artifact integrity, network exfiltration, and source exposure.
- Tier 2 matched expected scores on secret exposure, reduced token abuse, artifact integrity, network exfiltration, and source exposure.
- Tier 3 matched expected scores on secret exposure, token abuse, artifact integrity, output boundary safety, network exfiltration, and source exposure.
- Tier 4 matched expected scores on secret exposure, token abuse, artifact integrity, output boundary safety, network exfiltration, and source exposure.

## Operational Notes That Did Not Change Scores

### [Tier 4/Attestation Setup]
- Expected: Tier 4 would succeed with enterprise-style controls in place
- Actual: The first Tier 4 attestation run failed until `fulcio.sigstore.dev` and `rekor.sigstore.dev` were added to the hardened runner allowlist
- Explanation: The original release egress policy was too strict for Sigstore-backed attestation
- Impact on thesis: strengthens

### [Artifact Integrity/Local Hashing]
- Expected: Tier 3 and Tier 4 clean artifacts would match source
- Actual: Initial local comparison appeared to show a mismatch until the source hash was normalized to Linux `LF` line endings
- Explanation: The repo was prepared on Windows, while GitHub-hosted runners built the artifact on Linux
- Impact on thesis: none

## Takeaway

The benchmark held up well against its own pre-registration. The only surprises were operational:

- Tier 4 needed a realistic attestation-networking fix
- local Windows line endings required normalized hashing for fair artifact comparison

Neither changed the benchmark scores or weakened the core conclusion.
