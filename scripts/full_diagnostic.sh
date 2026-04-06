#!/usr/bin/env bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : full_diagnostic.sh
#  Objectif :
#     - Diagnostic complet du système
# ==============================================================================

set -euo pipefail

BASE_DIR="$(dirname "$(realpath "$0")")/../.."

echo "=== DIAGNOSTIC COMPLET — La Roulotte Solidaire Toulouse ==="

# --- Vérification API ---------------------------------------------------------
echo -e "\n--- API Ruby ---"
if curl -s http://localhost:4567/status >/dev/null; then
    echo "[OK] API accessible"
else
    echo "[ERREUR] API inaccessible"
fi

# --- Vérification scripts Bash ------------------------------------------------
echo -e "\n--- Scripts Bash ---"
for f in maintenance_roulotte.sh sync_git.sh cron_maintenance.sh; do
    if [[ -f "$BASE_DIR/scripts/maintenance/$f" ]]; then
        echo "[OK] $f présent"
    else
        echo "[ERREUR] $f manquant"
    fi
done

# --- Vérification scripts Python ---------------------------------------------
echo -e "\n--- Scripts Python ---"
if python3 "$BASE_DIR/scripts/maintenance/maintenance_report.py" --test >/dev/null 2>&1; then
    echo "[OK] Script Python fonctionnel"
else
    echo "[ERREUR] Problème avec maintenance_report.py"
fi

# --- Vérification systemd -----------------------------------------------------
echo -e "\n--- systemd ---"
for svc in roulotte-maintenance.service roulotte-syncgit.service; do
    systemctl is-active "$svc" >/dev/null 2>&1 && \
        echo "[OK] $svc actif" || echo "[ERREUR] $svc inactif"
done

# --- Vérification timers ------------------------------------------------------
echo -e "\n--- Timers ---"
systemctl list-timers --all | grep roulotte || echo "[ERREUR] Aucun timer actif"

# --- Vérification Git ---------------------------------------------------------
echo -e "\n--- Git ---"
cd "$BASE_DIR"
git status --short
git remote -v

# --- Vérification dossiers ----------------------------------------------------
echo -e "\n--- Dossiers essentiels ---"
for d in logs reports scripts docs; do
    [[ -d "$BASE_DIR/$d" ]] && echo "[OK] $d" || echo "[ERREUR] $d manquant"
done

echo -e "\n[OK] Diagnostic complet terminé."
