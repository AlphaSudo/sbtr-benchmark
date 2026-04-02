#!/bin/bash
set -euo pipefail

echo "========================================================"
echo "  SBTR BENCHMARK - Log Analysis"
echo "========================================================"

for TIER in 1 2 3 4; do
  LOG_DIR="evidence/tier-${TIER}"
  echo
  echo "========================================================"
  echo "  Tier $TIER"
  echo "========================================================"

  if [ ! -d "$LOG_DIR" ]; then
    echo "No evidence directory found. Skipping."
    continue
  fi

  LOG_FILES="$(find "$LOG_DIR" -type f \( -name '*.txt' -o -name '*.log' \) 2>/dev/null || true)"
  if [ -z "$LOG_FILES" ]; then
    echo "No extracted log files found. Unzip logs into $LOG_DIR first."
    continue
  fi

  SECRET_COUNT="$(grep -h 'Total secrets found in environment' $LOG_FILES 2>/dev/null | grep -oE '[0-9]+' | tail -1 || true)"
  TOKEN_WRITE="$(grep -h 'Can create releases' $LOG_FILES 2>/dev/null | grep -oE '[0-9]{3}' | tail -1 || true)"
  MEM_STATUS="$(grep -h 'Memory dump capability' $LOG_FILES 2>/dev/null | tail -1 || true)"
  EXFIL_STATUS="$(grep -h 'Outbound HTTP to external server' $LOG_FILES 2>/dev/null | tail -1 || true)"
  PAYLOAD_SIZE="$(grep -h 'Encoded payload ready' $LOG_FILES 2>/dev/null | grep -oE '[0-9]+' | tail -1 || true)"
  POISON_STATUS="$(grep -h 'Artifact poisoned successfully' $LOG_FILES 2>/dev/null | tail -1 || true)"
  SRC_COUNT="$(grep -h 'Source files found' $LOG_FILES 2>/dev/null | grep -oE '[0-9]+' | tail -1 || true)"
  GATE_STATUS="$(grep -h 'Outputs validated successfully\|OUTPUT INJECTION BLOCKED' $LOG_FILES 2>/dev/null | tail -1 || true)"

  echo "Secret exposure:     ${SECRET_COUNT:-0} secrets found"
  echo "Token write access:  HTTP ${TOKEN_WRITE:-N/A}"
  echo "Memory access:       ${MEM_STATUS:-N/A}"
  echo "Exfil HTTP:          ${EXFIL_STATUS:-N/A}"
  echo "Exfil payload size:  ${PAYLOAD_SIZE:-0} bytes"
  echo "Artifact poisoning:  ${POISON_STATUS:-not observed}"
  echo "Source files visible:${SRC_COUNT:-N/A}"
  if [ -n "${GATE_STATUS:-}" ]; then
    echo "Boundary gate:       $GATE_STATUS"
  fi
done
