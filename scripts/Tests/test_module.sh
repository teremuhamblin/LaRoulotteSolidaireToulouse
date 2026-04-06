#!/usr/bin/env bash
set -euo pipefail

MODULE="${1:-none}"
LOG_DIR="${HOME}/.local/share/roulotte-tests/logs"
mkdir -p "$LOG_DIR"

log() {
    echo "[MODULE:$MODULE][$(date '+%Y-%m-%d %H:%M:%S')] $1" \
        | tee -a "$LOG_DIR/test_${MODULE}.log"
}

if [[ "$MODULE" == "none" ]]; then
    echo "Usage: test_module.sh <module>"
    exit 1
fi

log "Test du module : $MODULE"

case "$MODULE" in
    dashboard)
        ./scripts/dashboard/run.sh --test && log "Dashboard OK"
        ;;
    forms)
        ./scripts/forms/run.sh --test && log "Forms OK"
        ;;
    logs)
        ./scripts/logs/run.sh --test && log "Logs OK"
        ;;
    sync)
        ./scripts/sync/run.sh --test && log "Sync OK"
        ;;
    *)
        log "Module inconnu"
        exit 1
        ;;
esac
