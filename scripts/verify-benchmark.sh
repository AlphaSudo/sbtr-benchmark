#!/bin/bash
set -euo pipefail

SOURCE="src/app.js"
SOURCE_HASH="$(sha256sum "$SOURCE" | cut -d' ' -f1)"
PASS=0
FAIL=0
WARN=0

echo "========================================================"
echo "  SBTR BENCHMARK - Automated Verification"
echo "========================================================"
echo "Source file:   $SOURCE"
echo "Source SHA256: $SOURCE_HASH"

for TIER in 1 2 3 4; do
  ARTIFACT="evidence/tier-${TIER}/artifact/app.js"
  echo
  echo "--------------------------------------------------------"
  echo "Tier $TIER"
  echo "--------------------------------------------------------"

  if [ ! -f "$ARTIFACT" ]; then
    echo "Artifact: not found"
    WARN=$((WARN + 1))
    continue
  fi

  ARTIFACT_HASH="$(sha256sum "$ARTIFACT" | cut -d' ' -f1)"
  echo "Artifact SHA256: $ARTIFACT_HASH"

  if [ "$ARTIFACT_HASH" = "$SOURCE_HASH" ]; then
    echo "Integrity: CLEAN"
    PASS=$((PASS + 1))
  else
    echo "Integrity: POISONED"
    diff "$SOURCE" "$ARTIFACT" || true
    FAIL=$((FAIL + 1))
  fi

  if grep -qE 'BACKDOOR|evil\.com|steal|fetch\(' "$ARTIFACT"; then
    echo "Backdoor signature: detected"
  else
    echo "Backdoor signature: not detected"
  fi
done

echo
echo "========================================================"
echo "Summary"
echo "========================================================"
echo "Clean artifacts:    $PASS"
echo "Poisoned artifacts: $FAIL"
echo "Missing artifacts:  $WARN"
