# Reproducibility And Release Checklist

Use this checklist when packaging the benchmark for others to rerun.

## Freeze The Benchmark

- [ ] Commit all workflow, evidence, and documentation updates
- [ ] Tag the final benchmark state
- [ ] Push tags to GitHub

## Include In The Release

- [ ] All workflow YAML files in [.github/workflows](.github/workflows)
- [ ] Malicious action source in [.github/actions/malicious-tool](.github/actions/malicious-tool)
- [ ] Evidence directory with logs, artifacts, comparison table, and per-tier scores in [evidence](evidence)
- [ ] Verification and analysis scripts in [scripts](scripts)
- [ ] Road map in [BENCHMARK_ROADMAP.md](BENCHMARK_ROADMAP.md)
- [ ] Reproduction instructions in [REPRODUCE.md](REPRODUCE.md)
- [ ] Final narrative summary in [RESULTS.md](RESULTS.md)
- [ ] Anomaly review in [ANOMALIES.md](ANOMALIES.md)
- [ ] Presentation package in [PRESENTATION.md](PRESENTATION.md)

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
