# Reproduction Guide

## Prerequisites

- GitHub account with Actions enabled
- Ability to create repository secrets
- Ability to create repository environments
- A public repository fork or clone of this project

## Time Required

- Setup: about 30 minutes
- Workflow runs: about 45 minutes
- Total: about 75 minutes

## 1. Fork Or Clone This Repository

Create a public repository from this project and push the contents.

## 2. Configure Repository Workflow Permissions

Go to `Settings -> Actions -> General`.

Set:

- `Workflow permissions` -> `Read and write permissions`

This is important because Tier 1 is supposed to demonstrate the insecure baseline, including write-capable token behavior.

## 3. Configure Secrets

Go to `Settings -> Secrets and variables -> Actions`.

Add these four repository secrets:

| Name | Value |
|---|---|
| `AWS_ACCESS_KEY_ID` | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `DEPLOY_TOKEN` | `ghp_fake0deploy0token0for0benchmark0only00` |
| `DATABASE_URL` | `postgres://user:pass@db.example.com:5432/prod` |

These are intentionally fake. Do not use real credentials.

## 4. Configure The Environment

Go to `Settings -> Environments -> New environment`.

Create:

- Name: `production`
- Required reviewer: yourself

## 5. Confirm The Ground-Truth Source Hash

The clean Linux-normalized source hash used for artifact comparison is:

```bash
c4657bc50ab6be26c54354f5304097ead527c46dbf2d72e0efbc35b1727b5988  src/app.js
```

If you want to recompute it locally on Linux:

```bash
sha256sum src/app.js
```

## 6. Run Workflows In Order

Go to the `Actions` tab and trigger each workflow with `workflow_dispatch`.

Run them in this order:

1. `Runner Baseline`
2. `Tier 1 - No Security`
3. `Tier 2 - SHA Pinned`
4. `Tier 3 - Trusted Release Boundary`
5. `Tier 4 - Enterprise`

For Tier 3 and Tier 4:

- wait for the untrusted lane to finish
- review its logs
- approve the `production` environment when prompted
- let the trusted release lane finish

## 7. Collect Evidence

For each workflow run:

1. Download the logs zip
2. Download the artifact zip if one was produced
3. Save them under the matching `evidence/tier-N/` folder locally
4. Record run URL, timestamps, and duration in that tier's `scores.md`

## 8. Verify The Artifacts

After downloading artifacts and logs into the `evidence/` layout, run:

```bash
bash scripts/verify-benchmark.sh
bash scripts/analyze-logs.sh
```

If you are on Windows and Git Bash is not available, use PowerShell to inspect the extracted files directly.

## 9. Compare Your Results To Ours

Use these reference files:

- [Results summary](RESULTS.md)
- [Comparison table](evidence/comparison-table.md)
- [Tier 1 scores](evidence/tier-1/scores.md)
- [Tier 2 scores](evidence/tier-2/scores.md)
- [Tier 3 scores](evidence/tier-3/scores.md)
- [Tier 4 scores](evidence/tier-4/scores.md)
- [Anomaly review](ANOMALIES.md)

## Expected Outcome

- Tier 1 should show broad compromise
- Tier 2 should show improved token scope, but still ship a poisoned artifact
- Tier 3 should keep the untrusted lane secretless and ship a clean rebuilt artifact
- Tier 4 should additionally block outbound exfiltration and complete attestation successfully

## Why Tier 1 And Tier 2 Expose Secrets

Tier 1 and Tier 2 intentionally place dummy secrets at the job scope so the malicious action can access them before deployment. That is deliberate for the benchmark. Tier 3 and Tier 4 remove secrets from the untrusted lane.
