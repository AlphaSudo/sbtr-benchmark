# Trusted Release Boundary Benchmark

## Goal

Validate that Tier 3 materially outperforms Tier 2 at near-zero tooling cost by running the same malicious action through four GitHub Actions architectures and comparing logs, artifact integrity, and operational overhead.

## Benchmark Shape

- `runner-baseline.yml` records the runner environment before the tier runs.
- `tier1-no-security.yml` is the control run.
- `tier2-sha-pinned.yml` is the pinning-only comparison.
- `tier3-trb.yml` is the candidate Trusted Release Boundary implementation.
- `tier4-enterprise.yml` is an optional enterprise reference point.

All workflows must run from the same baseline commit and be evaluated with the same scoring rubric.

## Manual Preconditions

1. Create a fresh public repository named `sbtr-benchmark`.
2. Set repository default workflow permissions to `Read and write permissions` before running Tier 1.
3. Add these repository secrets with dummy values:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `DEPLOY_TOKEN`
   - `DATABASE_URL`
4. Create a protected environment named `production` with yourself as required reviewer.
5. Tag the initial frozen benchmark commit, for example `benchmark-v1`, before running any tier.

## Run Order

1. `Runner Baseline`
2. `Tier 1 - No Security`
3. `Tier 2 - SHA Pinned`
4. `Tier 3 - Trusted Release Boundary`
5. `Tier 4 - Enterprise` (optional)

## Metrics

Score each tier on:

- `Secret exposure`
- `Token abuse`
- `Artifact integrity`
- `Output boundary safety`
- `Network exfiltration`
- `Source exposure`

Use the strict `0/1/2` rubric in [expected-results.md](expected-results.md). Exclude `N/A` from the composite denominator.

Composite score:

```text
100 - (sum(actual metric scores) / sum(max scores for applicable metrics)) * 100
```

Track operational metrics separately:

- Setup effort
- CI duration
- YAML complexity
- New dependencies
- Annual cost

## Success Criteria

- Tier 1 demonstrates secret exposure and shipped artifact poisoning.
- Tier 2 improves token scope only.
- Tier 3 keeps secrets out of the untrusted lane, validates boundary outputs, and ships a clean rebuilt artifact.
- Tier 2 to Tier 3 shows a meaningful security gain with no paid tooling.
- Tier 4, if run, improves mainly on egress control, detection, and provenance.

## Notes

- This benchmark intentionally uses a public repository, so `Source exposure` is capped at `1`.
- Tier 4 attestation is configured for current public-repo GitHub support. Private/internal attestation availability depends on GitHub Enterprise Cloud.
- The output-validation job in Tier 3 is a benchmark demo allowlist, not a production-grade sanitizer.
