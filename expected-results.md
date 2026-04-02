# Pre-Registered Expected Results

These scores are hypotheses to keep the benchmark honest. If the actual outcome differs, record the difference and keep it in the final comparison.

## Tier 1

- Secret exposure: `2`
- Token abuse: `2`
- Artifact integrity: `2`
- Output boundary: `N/A`
- Network exfil: `2`
- Source exposure: `1`

## Tier 2

- Secret exposure: `2`
- Token abuse: `1`
- Artifact integrity: `2`
- Output boundary: `N/A`
- Network exfil: `2`
- Source exposure: `1`

## Tier 3

- Secret exposure: `0`
- Token abuse: `1`
- Artifact integrity: `0`
- Output boundary: `0`
- Network exfil: `1`
- Source exposure: `1`

## Tier 4

- Secret exposure: `0`
- Token abuse: `1`
- Artifact integrity: `0`
- Output boundary: `0`
- Network exfil: `0`
- Source exposure: `1`

## Scoring Notes

- This benchmark assumes a public repository, so `Source exposure` is capped at `1`.
- Tier 4 is optional and is mainly used as an upper-bound comparison.
- `Output boundary` is only scored for workflows with a real cross-job trust boundary.
