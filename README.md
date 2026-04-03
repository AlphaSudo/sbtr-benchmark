# Trusted Release Boundary - Benchmark

A reproducible benchmark showing that CI architecture, not just SHA pinning, is what materially limits supply-chain attacks like CVE-2025-30066 (`tj-actions/changed-files`).

## The Finding

| Tier | Architecture | Score | Annual Cost |
|---|---|---:|---|
| 1 | No security | 10/100 | $0 |
| 2 | SHA-pinned (typical AI advice) | 20/100 | $0 |
| 3 | Trusted Release Boundary | 75/100 | $0 |
| 4 | Enterprise (egress + attestation) | 83/100 | enterprise-style overhead |

Tier 3 closes the largest security gap at zero tooling cost.

## Why You Should Care

Most CI hardening advice stops at:

- pin actions by SHA
- reduce `GITHUB_TOKEN` permissions
- add selective hardening later

Those are useful, but they do not solve the core problem:

If untrusted third-party code runs in the same job as secrets and release authority, a compromised action can still steal secrets, poison artifacts, and exfiltrate data.

This benchmark isolates that exact question by running the same malicious action against four different workflow architectures.

## What Was Tested

A simulated malicious GitHub Action, modeled on the behavior class exposed by CVE-2025-30066, ran the same six attack behaviors in every tier:

1. Environment variable dumping
2. `GITHUB_TOKEN` permission probing
3. Process memory access checks
4. Network exfiltration attempts
5. Artifact poisoning
6. Source enumeration

The only changing variable was the workflow design.

[Full benchmark results ->](RESULTS.md)

## Reproduce It Yourself

1. Fork this repository
2. Add four dummy secrets
3. Create a `production` environment with required reviewers
4. Run the workflows in order
5. Compare the artifact hashes and logs

[Step-by-step reproduction guide ->](REPRODUCE.md)

## The Framework: 6 Rules

| Rule | Name | Purpose |
|---|---|---|
| 0 | PIN | Use immutable SHA references for all external actions |
| 1 | QUARANTINE | Untrusted lane gets no secrets and no write authority |
| 2 | ISOLATE | Trusted lane is separate and first-party only |
| 3 | REBUILD | Trusted lane rebuilds from source on a fresh runner |
| 4 | ARTIFACT QUARANTINE | Only metadata crosses the boundary, never untrusted binaries |
| 5 | VALIDATE | Outputs crossing the boundary are explicitly sanitized |

## Source Hash (Ground Truth)

GitHub-hosted runners built the artifacts from Linux checkouts with `LF` line endings. That normalized source hash is the ground truth for clean artifact comparison:

```bash
$ sha256sum src/app.js
c4657bc50ab6be26c54354f5304097ead527c46dbf2d72e0efbc35b1727b5988  src/app.js
```

## Evidence

- [Tier 1 scores](evidence/tier-1/scores.md)
- [Tier 2 scores](evidence/tier-2/scores.md)
- [Tier 3 scores](evidence/tier-3/scores.md)
- [Tier 4 scores](evidence/tier-4/scores.md)
- [Comparison table](evidence/comparison-table.md)
- [Pre-registered expected results](expected-results.md)
- [Anomaly review](ANOMALIES.md)

## Caveats

- This repo is public, so source exposure impact is capped relative to a private-repo benchmark
- The malicious action is a controlled simulation, not a live attacker
- Windows `CRLF` vs Linux `LF` normalization affected raw local hashes; artifact verification used the normalized Linux hash above
- Tier 4 initially failed attestation until Sigstore endpoints were allowlisted through the hardened release egress policy

## Repo Layout

```text
.github/actions/malicious-tool/   simulated compromised action
.github/workflows/                baseline and tier workflows
evidence/                         extracted logs, artifacts, score sheets, comparison table
scripts/                          local verification helpers
src/app.js                        deterministic source input
REPRODUCE.md                      end-to-end rerun instructions
RESULTS.md                        narrative benchmark results
PRESENTATION.md                   short presentation / video notes
```

## License

MIT
