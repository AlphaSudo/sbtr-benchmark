# Trusted Release Boundary

## A Reproducible Benchmark for Containing CI Supply-Chain Attacks in GitHub Actions

## Abstract

Modern CI security guidance often emphasizes action SHA pinning, token permission scoping, and selective hardening controls. These practices are useful, but they do not answer the central architectural question: what happens when compromised third-party code executes in the same trust domain as deployment secrets and release authority?

This repository presents a reproducible benchmark designed to answer that question. We evaluate four GitHub Actions workflow architectures against the same simulated malicious action modeled on the behavior class exposed by CVE-2025-30066 (`tj-actions/changed-files`). The benchmark compares an insecure baseline, a SHA-pinned variant, a boundary-based design called Trusted Release Boundary (TRB), and an enterprise-style design that adds egress restriction and artifact attestation.

The result is clear. SHA pinning alone improves token abuse resistance but does not prevent same-job secret exposure or poisoned artifact release. By contrast, a trusted release boundary, which isolates untrusted execution from trusted release, validates outputs at the boundary, and rebuilds artifacts from source on a fresh runner, materially reduces blast radius at zero tooling cost. An enterprise tier improves further by restricting network egress and adding provenance, but the largest cost-effective security gain comes from the architectural boundary itself.

Repository:

[https://github.com/AlphaSudo/sbtr-benchmark](https://github.com/AlphaSudo/sbtr-benchmark)

## 1. Introduction

Software supply-chain attacks increasingly target CI/CD systems because they concentrate source access, credentials, release authority, and artifact generation in one place. In GitHub Actions in particular, developers frequently compose workflows out of third-party actions that execute with access to repository contents, workflow tokens, and sometimes deployment secrets.

The common defensive advice is straightforward:

- pin actions by immutable SHA
- reduce `GITHUB_TOKEN` permissions
- add environment approvals
- layer on hardening later

Those are all worthwhile practices. The problem is that they are often treated as sufficient when they are not. If a malicious or compromised action runs in the same job that holds secrets and generates deployable artifacts, then the trust collapse has already happened. Pinning a malicious SHA does not make it less malicious. Scoping a token does not stop environment dumping, process memory scraping, artifact poisoning, or outbound exfiltration when the attack already executes in the trusted lane.

This benchmark was built to test that exact gap.

The central thesis is:

> The most important CI security control is not pinning alone. It is architectural separation between untrusted execution and trusted release.

We call that separation the Trusted Release Boundary.

## 2. Problem Statement

The benchmark addresses a practical question:

> Does a low-cost architectural change, a trusted release boundary, materially outperform SHA pinning alone when a third-party GitHub Action is compromised?

That question matters because many real-world teams can adopt multi-job workflow structure, secret isolation, and fresh-runner rebuilds long before they can adopt enterprise controls such as self-hosted isolated runners, commercial network egress policy tools, or full provenance pipelines.

The benchmark therefore compares four tiers:

1. Tier 1: No security
2. Tier 2: SHA-pinned, scoped token
3. Tier 3: Trusted Release Boundary
4. Tier 4: Enterprise-style hardening

The purpose is not to prove that enterprise controls are unnecessary. The purpose is to identify which control changes the blast radius most per unit of adoption cost.

## 3. Threat Model

### 3.1 Attacker Model

The attacker controls or compromises a third-party GitHub Action that is invoked by the workflow. Once executed, the action behaves as a valid action from the workflow engine’s perspective and can run arbitrary shell logic inside the job where it is called.

The attacker’s goals are:

- steal secrets from environment variables or process memory
- abuse the workflow token
- exfiltrate sensitive data over the network
- poison the generated build artifact
- inspect or steal source code

### 3.2 Out of Scope

The benchmark is not a complete application security review. It does not attempt to model:

- vulnerabilities in the application itself
- malicious maintainers of the repository
- cloud-side compromise after deployment
- organization-wide policy bypass outside the repository

It isolates the GitHub Actions runtime and the trust boundary between untrusted CI execution and trusted artifact release.

### 3.3 Why CVE-2025-30066 Matters

The simulated action is modeled on the attack behavior class exposed by CVE-2025-30066 involving `tj-actions/changed-files`. The specific benchmark action performs six behaviors chosen because they map to realistic CI compromise paths:

1. Environment dumping
2. `GITHUB_TOKEN` probing
3. Process memory access checks
4. Exfiltration attempts
5. Artifact poisoning
6. Source enumeration

The benchmark does not claim to replay the historical incident byte-for-byte. Instead, it uses a controlled malicious action that expresses the same risk class under reproducible conditions.

## 4. The Trusted Release Boundary Framework

The framework that emerged from the experiment is:

| Rule | Name | Meaning |
|---|---|---|
| 0 | PIN | Use immutable SHAs for external actions |
| 1 | QUARANTINE | The untrusted lane gets no deployment secrets and no write authority |
| 2 | ISOLATE | The trusted release lane is separate and first-party only |
| 3 | REBUILD | The trusted lane rebuilds from source on a fresh runner |
| 4 | ARTIFACT QUARANTINE | Untrusted binaries never cross the boundary into release |
| 5 | VALIDATE | Outputs crossing the boundary are explicitly validated |

These rules are deliberately ordered. Pinning is still present, but it is the first layer, not the entire strategy.

The core insight is that compromised code should be assumed possible. Once that assumption is made, the design target becomes containment rather than wishful prevention.

## 5. Benchmark Design

### 5.1 Experimental Goal

The benchmark was designed to hold the following constant:

- same repository
- same source file
- same malicious action behavior
- same GitHub Actions platform

The only intended variable was workflow architecture.

### 5.2 Benchmark Artifact

The application under test is intentionally trivial:

- `src/app.js` is a minimal deterministic source input
- `deploy.sh` is a simulated deployment stub

This keeps the benchmark focused on CI trust boundaries instead of application complexity.

### 5.3 Four-Tier Comparison

#### Tier 1: No Security

Characteristics:

- mutable or non-boundary-aware workflow shape
- same job for untrusted action and deployment secrets
- artifact generated and shipped from the same compromised workspace

Expected result:

- full compromise

#### Tier 2: SHA-Pinned

Characteristics:

- action pinning
- scoped workflow permissions
- still same-job secrets and release

Expected result:

- reduced token abuse only

#### Tier 3: Trusted Release Boundary

Characteristics:

- deny-by-default workflow permissions
- untrusted analyze/test lane without secrets
- separate validation gate
- separate trusted release lane
- fresh checkout and rebuild from source

Expected result:

- attack contained

#### Tier 4: Enterprise

Characteristics:

- Tier 3 boundary preserved
- hardened runner egress restriction
- artifact attestation

Expected result:

- attack contained with lower exfiltration risk and stronger provenance

### 5.4 Pre-Registration

The expected scoring outcomes were written into `expected-results.md` before the final benchmark interpretation. This matters because it reduces the temptation to adjust the story after observing the outcome.

That pre-registration is modest rather than statistical, but it still increases credibility by making the benchmark falsifiable at the metric level.

## 6. Metrics

Each tier was scored across six security dimensions:

- Secret exposure
- Token abuse
- Artifact integrity
- Output boundary safety
- Network exfiltration
- Source exposure

Scores use a `0/1/2` risk scale:

- `0` means strong containment on that metric
- `1` means partial exposure or reduced risk
- `2` means clear failure on that metric

Composite scores are normalized to a 100-point scale, where higher is better.

Operational metrics were also tracked separately:

- setup effort
- CI duration
- complexity
- annual cost

This separation is important. A benchmark that only reports security outcomes can hide adoption cost. A benchmark that only reports convenience can hide real risk.

## 7. Implementation

### 7.1 Malicious Action

The local malicious composite action performs the six attacker behaviors described above. It is deliberately visible and noisy because the point is reproducibility, not stealth.

### 7.2 Tier 1 Workflow

Tier 1 intentionally places dummy secrets at the job scope so the malicious action can access them before deployment. This is not an accident in the benchmark; it is the insecure condition being measured.

### 7.3 Tier 2 Workflow

Tier 2 keeps the same insecure trust structure but introduces SHA pinning and reduced token permissions. This isolates the incremental value of those controls.

### 7.4 Tier 3 Workflow

Tier 3 implements the full TRB pattern:

- untrusted lane
- explicit validation gate
- trusted release lane
- fresh rebuild from source

This workflow is the benchmark’s candidate solution.

### 7.5 Tier 4 Workflow

Tier 4 extends Tier 3 with:

- `step-security/harden-runner`
- outbound egress restrictions
- `actions/attest-build-provenance`

The benchmark uncovered a real operational requirement here: Sigstore endpoints had to be allowlisted for attestation to succeed.

That is not a flaw in the benchmark. It is a useful demonstration that enterprise controls add both security and configuration burden.

## 8. Results

### 8.1 Final Score Table

| Tier | Score | Interpretation |
|---|---:|---|
| Tier 1 | 10/100 | broad compromise |
| Tier 2 | 20/100 | better token scope, but same-job trust collapse remains |
| Tier 3 | 75/100 | strong low-cost containment |
| Tier 4 | 83/100 | strongest result after adding egress restriction and attestation |

### 8.2 Tier-by-Tier Findings

#### Tier 1

Observed behavior:

- secrets found in the environment
- write-capable release path available via token behavior
- outbound exfiltration successful
- artifact poisoned and shipped

Interpretation:

This is what full CI trust collapse looks like. Compromised code has everything it needs because the workflow architecture gives it everything in one place.

#### Tier 2

Observed behavior:

- same secret exposure as Tier 1
- token write behavior reduced
- outbound exfiltration still successful
- artifact still poisoned and shipped

Interpretation:

Pinning and token scoping are helpful, but the architecture is still wrong. The malicious action continues to execute in the same trust domain as the release path.

#### Tier 3

Observed behavior:

- no secrets in the untrusted lane
- token write behavior blocked
- output validation succeeded
- clean artifact rebuilt from source in the trusted lane

Interpretation:

This is the key result of the benchmark. The malicious action still runs, but it cannot meaningfully affect release integrity because it never enters the trusted release domain.

#### Tier 4

Observed behavior:

- no secrets in the untrusted lane
- token write behavior blocked
- outbound exfiltration blocked
- validation gate succeeded
- clean artifact rebuilt and attested successfully

Interpretation:

Tier 4 is strongest overall, but its improvement over Tier 3 is incremental compared with the large security jump already achieved by architectural separation.

## 9. Discussion

### 9.1 Why Tier 3 Matters Most

The benchmark suggests that Tier 3 is the highest-leverage control for most teams because it changes the blast radius without requiring:

- paid tooling
- platform engineering headcount
- self-hosted runner infrastructure

That matters because a security model that only works for well-funded platform teams leaves most repositories exposed.

Tier 3 is not “enterprise complete,” but it moves the repository from same-job trust collapse to meaningful containment.

### 9.2 Why SHA Pinning Is Not Enough

SHA pinning is often treated as a decisive answer to action compromise. The benchmark shows why that framing is incomplete.

Pinning protects against moving tags and some classes of update drift. It does not help if:

- the pinned version is already malicious
- the pinned version contains a zero-day
- the maintainer itself is compromised

Pinning is still valuable. It is simply not a containment strategy.

### 9.3 Why Enterprise Controls Still Matter

Tier 4 proves that enterprise additions are meaningful:

- network exfiltration can be blocked
- provenance can be established
- release behavior can become more observable and restrictive

But the benchmark also shows that enterprise controls are not a substitute for the boundary model. In fact, Tier 4 only becomes conceptually clean once it preserves the Tier 3 validation gate and rebuild model.

## 10. Anomalies And Operational Lessons

The final benchmark scores matched the pre-registered expectations.

Two operational lessons emerged:

1. Tier 4 attestation initially failed until Sigstore endpoints were explicitly allowlisted through the hardened runner policy.
2. Local Windows hashing initially disagreed with GitHub-hosted runner artifacts because the local file used `CRLF` while the Linux runner used `LF`. Artifact comparison was therefore anchored to the normalized Linux source hash.

Neither issue changed the metric outcomes, but both are important for reproducibility.

## 11. Limitations

This work has several limitations.

### 11.1 Public Repository

The benchmark repository is public, so source exposure is intentionally capped in impact compared with a private-repo scenario.

### 11.2 Simulated Attacker

The malicious action is controlled and reproducible, not evasive or adaptive. A real attacker would likely attempt stealthier tradecraft.

### 11.3 Narrow Platform Scope

The benchmark is specific to GitHub Actions. The architectural lesson generalizes, but the exact mechanics are platform-specific.

### 11.4 No Statistical Claims

This is not a large-sample empirical study. It is a controlled reproducibility benchmark focused on architecture, not population-level measurement.

## 12. Conclusion

The benchmark supports the following conclusion:

> The single most important low-cost CI security improvement is establishing a trusted release boundary between untrusted third-party execution and trusted release.

Tier 1 and Tier 2 show that same-job trust collapse remains dangerous even when SHA pinning and token scoping are applied. Tier 3 shows that architectural separation, validation, and fresh rebuilds from source materially change the attack outcome. Tier 4 demonstrates that enterprise controls strengthen the design further, but the decisive shift happens when the release path stops trusting the untrusted lane.

In practical terms:

- pinning is necessary
- scoping is necessary
- hardening is useful
- but architecture is what changes the blast radius

That is the core finding of this repository.

## Appendix A: Repository Artifacts

- [README.md](README.md)
- [REPRODUCE.md](REPRODUCE.md)
- [RESULTS.md](RESULTS.md)
- [ANOMALIES.md](ANOMALIES.md)
- [PRESENTATION.md](PRESENTATION.md)
- [Comparison table](evidence/comparison-table.md)
- [Tier 1 score sheet](evidence/tier-1/scores.md)
- [Tier 2 score sheet](evidence/tier-2/scores.md)
- [Tier 3 score sheet](evidence/tier-3/scores.md)
- [Tier 4 score sheet](evidence/tier-4/scores.md)
