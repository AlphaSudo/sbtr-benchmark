# Reproduce The Benchmark

## Setup

1. Create a new public GitHub repository and push this directory to it.
2. In the repository settings, set default workflow permissions to `Read and write permissions` for the Tier 1 control run.
3. Add dummy secrets:
   - `AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE`
   - `AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`
   - `DEPLOY_TOKEN=ghp_fake0deploy0token0for0benchmark0only00`
   - `DATABASE_URL=postgres://user:pass@db.example.com:5432/prod`
4. Create the `production` environment with yourself as a required reviewer.
5. Record the source hash:

```bash
sha256sum src/app.js
```

6. Commit and tag the frozen baseline:

```bash
git add .
git commit -m "Add TRB benchmark scaffold"
git tag benchmark-v1
git push origin main --tags
```

## Execute The Benchmark

Run the workflows in this order from the Actions tab:

1. `Runner Baseline`
2. `Tier 1 - No Security`
3. `Tier 2 - SHA Pinned`
4. `Tier 3 - Trusted Release Boundary`
5. `Tier 4 - Enterprise` (optional)

For Tier 3 and Tier 4:

- Let the untrusted job finish.
- Review its logs.
- Approve the `production` environment.

For each workflow run:

1. Download the logs zip.
2. Download the artifact if one was produced.
3. Save them under `evidence/tier-N/`.
4. Record run URL, UTC timestamps, and workflow duration in that tier's `scores.md`.

## Verify Artifacts

After downloading artifacts into `evidence/`, run:

```bash
bash scripts/verify-benchmark.sh
```

To extract the main attack signals from log files that have already been unzipped under `evidence/`, run:

```bash
bash scripts/analyze-logs.sh
```

## Interpret Results

- Tier 1 should show broad compromise.
- Tier 2 should show better token scope but still poisoned shipped artifacts.
- Tier 3 should keep the untrusted lane secretless and ship a clean artifact rebuilt in the trusted lane.
- Tier 4 should additionally restrict egress and produce provenance metadata.

Any mismatch between expected and actual results should be documented, not edited away.
## Why Tier 1 And Tier 2 Expose Secrets

Those two workflows intentionally place the dummy secrets at the job scope so the malicious action can access them before deployment. That is deliberate for the benchmark. Tier 3 moves secrets entirely out of the untrusted lane.
