#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="${HOME}/.local/share/roulotte-tests/logs"
mkdir -p "$LOG_DIR"

log() {
    echo "[TEST][$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_DIR/test_install.log"
}

log "=== DÉMARRAGE DES TESTS 1.2.0 ==="

log "Test 1 : Dashboard TUI"
./scripts/tests/test_module.sh dashboard || log "ERREUR: dashboard"

log "Test 2 : Formulaires terrain"
./scripts/tests/test_module.sh forms || log "ERREUR: forms"

log "Test 3 : Logs avancés"
./scripts/tests/test_module.sh logs || log "ERREUR: logs"

log "Test 4 : Sync Cloud"
./scripts/tests/test_module.sh sync || log "ERREUR: sync"

log "Test 5 : Dry-run"
./scripts/tests/test_dry_run.sh || log "ERREUR: dry-run"

log "=== FIN DES TESTS ==="
