# Trusted Release Boundary Benchmark Results

## Executive Summary

This benchmark tested the same simulated malicious GitHub Action across four CI architectures to measure how much security each tier buys relative to its cost and complexity.

The result was clear:

- Tier 1 (`No Security`) was broadly compromised.
- Tier 2 (`SHA Pinned`) improved token scope, but still exposed secrets and shipped a poisoned artifact.
- Tier 3 (`Trusted Release Boundary`) kept secrets out of the untrusted lane and shipped a clean rebuilt artifact with no added paid tooling.
- Tier 4 (`Enterprise`) built on Tier 3 by adding egress blocking and artifact attestation, producing the strongest overall result after a small allowlist fix for Sigstore endpoints.

## Final Scores

| Tier | Score | Key Outcome |
|---|---:|---|
| Tier 1 | 10/100 | Secrets exposed, write-capable token, poisoned artifact shipped |
| Tier 2 | 20/100 | Token abuse reduced, but secrets still exposed and poisoned artifact still shipped |
| Tier 3 | 75/100 | Secrets removed from untrusted lane, explicit boundary validation, clean rebuilt artifact |
| Tier 4 | 83/100 | Tier 3 controls plus blocked egress and successful provenance attestation |

## What We Tested

The malicious composite action simulated six supply-chain attack behaviors:

1. Environment variable dumping
2. `GITHUB_TOKEN` permission probing
3. Process memory access checks
4. Network exfiltration attempts
5. Artifact poisoning
6. Source enumeration

Each tier was evaluated against the same attack behavior so the only changing variable was the CI architecture.

## Results By Tier

### Tier 1: No Security

Tier 1 put third-party code and deployment secrets in the same job with permissive defaults. The attack found secrets in the environment, successfully used a write-capable token path, poisoned the artifact, and shipped the poisoned result.

Evidence highlights:

- `Total secrets found in environment: 3`
- `Can create releases: 201`
- `Outbound HTTP to external server: 200`
- Backdoor signature detected in shipped artifact

### Tier 2: SHA Pinned

Tier 2 improved one thing: token scope. The token could no longer create releases. But the malicious action still ran in the same job as secrets, still exfiltrated data, and still poisoned the artifact that got shipped.

Evidence highlights:

- `Total secrets found in environment: 3`
- `Can create releases: 403`
- `Outbound HTTP to external server: 200`
- Backdoor signature detected in shipped artifact

Conclusion: pinning and permission scoping help, but they do not solve same-job trust collapse.

### Tier 3: Trusted Release Boundary

Tier 3 separated the untrusted lane from the trusted release lane. The malicious action still ran, but it had no secrets to steal, could not use a write-capable token, and its poisoned workspace never crossed into the release path. A validation job checked outputs before the trusted job rebuilt from source on a fresh runner.

Evidence highlights:

- `Total secrets found in environment: 0`
- `Can create releases: 403`
- `Outputs validated successfully`
- Artifact hash matched normalized source hash

Conclusion: Tier 3 delivered the biggest security improvement for the smallest implementation cost.

### Tier 4: Enterprise

Tier 4 preserved the Tier 3 boundary model and added hardened-runner egress blocking plus artifact attestation. The first attestation attempt failed because the hardened release lane needed Sigstore endpoints allowlisted. After adding `fulcio.sigstore.dev` and `rekor.sigstore.dev`, the release succeeded.

Evidence highlights from the final successful run:

- `Total secrets found in environment: 0`
- `Can create releases: 403`
- `Outbound HTTP to external server: 000blocked`
- `Outputs validated successfully`
- Artifact hash matched normalized source hash
- Release succeeded with attestation enabled

Conclusion: Tier 4 was strongest overall, but it required more workflow complexity and more operational tuning.

## Main Takeaway

The benchmark supports the core thesis:

Tier 3 is the most cost-effective step change in CI security.

It closes the largest gap between insecure/default workflows and enterprise-grade hardening without requiring paid tooling, custom infrastructure, or a platform team. Tier 4 is stronger, but Tier 3 delivers the best security return for the smallest adoption cost.

## Important Caveats

- This benchmark repo is public, so source exposure is capped in impact relative to a private-repo scenario.
- The malicious action is a controlled simulation, not a live attacker.
- Local Windows line endings changed the raw hash of `src/app.js`; artifact integrity comparisons were validated against the normalized Linux `LF` source hash used by GitHub-hosted runners.
- Tier 4 required a real-world style fix: the hardened release lane needed Sigstore endpoints allowed for attestation to succeed.

## Evidence Index

- Summary table: [comparison-table.md](evidence/comparison-table.md)
- Tier 1 details: [scores.md](evidence/tier-1/scores.md)
- Tier 2 details: [scores.md](evidence/tier-2/scores.md)
- Tier 3 details: [scores.md](evidence/tier-3/scores.md)
- Tier 4 details: [scores.md](evidence/tier-4/scores.md)
