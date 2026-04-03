# Presentation Pack

## Video Script Alignment

| Video Moment | Evidence Source |
|---|---|
| "Here's what a compromised action does" | [Tier 1 scores](C:/Java%20Developer/TRB/evidence/tier-1/scores.md) plus the extracted logs in [tier-1](C:/Java%20Developer/TRB/evidence/tier-1) |
| "SHA-pinning doesn't help when you pin the wrong thing" | [Tier 2 scores](C:/Java%20Developer/TRB/evidence/tier-2/scores.md) and the poisoned Tier 2 artifact in [tier-2](C:/Java%20Developer/TRB/evidence/tier-2) |
| "The fix costs $0 and takes about 90 minutes" | [Tier 3 scores](C:/Java%20Developer/TRB/evidence/tier-3/scores.md) and the clean rebuilt artifact in [tier-3](C:/Java%20Developer/TRB/evidence/tier-3) |
| "The artifact proof" | Hash comparison evidence across [tier-1](C:/Java%20Developer/TRB/evidence/tier-1), [tier-2](C:/Java%20Developer/TRB/evidence/tier-2), [tier-3](C:/Java%20Developer/TRB/evidence/tier-3), and [tier-4](C:/Java%20Developer/TRB/evidence/tier-4) |
| "The comparison" | [comparison-table.md](C:/Java%20Developer/TRB/evidence/comparison-table.md) |

## Short Video / Demo Script

### Opening

This benchmark asks a simple question: if the exact same malicious GitHub Action runs in four different CI architectures, what actually changes? Not the codebase. Not the attack. Just the architecture.

### Tier 1

Tier 1 is the default failure mode. Third-party code runs in the same job as secrets. The action finds secrets, confirms token abuse, poisons the artifact, and the poisoned artifact ships.

### Tier 2

Tier 2 looks safer. It uses SHA pinning and reduced token permissions. That helps on token abuse, but it does not solve same-job trust collapse. Secrets are still exposed and the poisoned artifact still ships.

### Tier 3

Tier 3 changes the model. The malicious action still runs, but only in an untrusted lane with no deployment secrets and no write-capable token. Outputs cross a validation gate, then the trusted release lane rebuilds from source on a fresh runner. The shipped artifact is clean.

### Tier 4

Tier 4 keeps the Tier 3 boundary and adds hardened network egress plus artifact attestation. After allowing the Sigstore endpoints required for attestation, the release succeeds and outbound exfiltration from the untrusted lane is blocked.

### Closing

The conclusion is not that Tier 4 is unnecessary. It is that Tier 3 is the biggest practical jump in security for the smallest cost. Architecture, not pinning alone, is what changes the blast radius.

## One-Slide Summary

```text
THE CI SECURITY STAIRCASE — Benchmark Results

Tier 4  Enterprise     █████████████████████░ 83/100  enterprise-style overhead
Tier 3  TRB            ███████████████████░░ 75/100  $0
         --- biggest low-cost security jump ---
Tier 2  SHA-Pin        ████░░░░░░░░░░░░░░░░░ 20/100  $0
Tier 1  No Security    ██░░░░░░░░░░░░░░░░░░ 10/100  $0

Same attack. Same codebase. Architecture is the variable.
```

## README / Post Summary

This benchmark compared four GitHub Actions security tiers against the same malicious-action simulation.

- Tier 1 failed broadly.
- Tier 2 improved token scope only.
- Tier 3 introduced a true trust boundary and clean rebuild path.
- Tier 4 added egress blocking and attestation on top of the Tier 3 model.

The practical takeaway is that Tier 3 is the highest-leverage improvement for most teams because it materially reduces blast radius without requiring paid tooling or platform engineering.
