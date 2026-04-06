#!/usr/bin/env bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : check_systemd_status.sh
#  Objectif :
#     - Vérifier l'état des services systemd
#     - Afficher les dernières exécutions
# ==============================================================================

set -euo pipefail

echo "=== Vérification des services systemd de la Roulotte ==="

SERVICES=(
    "roulotte-maintenance.service"
    "roulotte-syncgit.service"
)

TIMERS=(
    "roulotte-maintenance.timer"
    "roulotte-syncgit.timer"
)

# Vérification des services
echo -e "\n--- Services ---"
for svc in "${SERVICES[@]}"; do
    echo -n "$svc : "
    systemctl is-active "$svc" >/dev/null 2>&1 && echo "ACTIF" || echo "INACTIF"
done

# Vérification des timers
echo -e "\n--- Timers ---"
for tmr in "${TIMERS[@]}"; do
    echo -n "$tmr : "
    systemctl is-active "$tmr" >/dev/null 2>&1 && echo "ACTIF" || echo "INACTIF"
done

# Dernières exécutions
echo -e "\n--- Dernières exécutions ---"
systemctl list-timers --all | grep roulotte || echo "Aucun timer trouvé."

# Logs
echo -e "\n--- Logs récents ---"
journalctl -u roulotte-maintenance.service -n 20 --no-pager
journalctl -u roulotte-syncgit.service -n 20 --no-pager

echo -e "\n[OK] Vérification terminée."
