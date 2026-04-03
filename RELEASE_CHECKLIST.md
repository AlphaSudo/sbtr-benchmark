# Reproducibility And Release Checklist

Use this checklist when packaging the benchmark for others to rerun.

## Freeze The Benchmark

- [ ] Commit all workflow, evidence, and documentation updates
- [ ] Tag the final benchmark state
- [ ] Push tags to GitHub

## Include In The Release

- [ ] All workflow YAML files in [.github/workflows](C:/Java%20Developer/TRB/.github/workflows)
- [ ] Malicious action source in [.github/actions/malicious-tool](C:/Java%20Developer/TRB/.github/actions/malicious-tool)
- [ ] Evidence directory with logs, artifacts, comparison table, and per-tier scores in [evidence](C:/Java%20Developer/TRB/evidence)
- [ ] Verification and analysis scripts in [scripts](C:/Java%20Developer/TRB/scripts)
- [ ] Road map in [BENCHMARK_ROADMAP.md](C:/Java%20Developer/TRB/BENCHMARK_ROADMAP.md)
- [ ] Reproduction instructions in [REPRODUCE.md](C:/Java%20Developer/TRB/REPRODUCE.md)
- [ ] Final narrative summary in [RESULTS.md](C:/Java%20Developer/TRB/RESULTS.md)
- [ ] Anomaly review in [ANOMALIES.md](C:/Java%20Developer/TRB/ANOMALIES.md)
- [ ] Presentation package in [PRESENTATION.md](C:/Java%20Developer/TRB/PRESENTATION.md)

## Release Notes Talking Points

- [ ] Tier 1 shows full compromise in a same-job secret model
- [ ] Tier 2 shows SHA pinning is not a containment strategy
- [ ] Tier 3 shows the value of a trusted release boundary at zero tooling cost
- [ ] Tier 4 shows the additional benefits and tuning overhead of egress blocking plus attestation
- [ ] Mention the Sigstore allowlist fix as a real operational lesson
- [ ] Mention Windows vs Linux line-ending normalization for artifact hashing

## Reproduction Promise

Anyone should be able to:

1. Fork the repo
2. Add four dummy secrets
3. Create a `production` environment
4. Run the workflows in order
5. Reproduce the benchmark within roughly an hour
