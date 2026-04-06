#!/usr/bin/env bash
# ==============================================================================
#  Dashboard CLI — La Roulotte Solidaire Toulouse
# ==============================================================================

BASE_DIR="$(dirname "$(realpath "$0")")/../.."

clear
echo "==============================================="
echo "   DASHBOARD — La Roulotte Solidaire Toulouse"
echo "==============================================="

echo -e "\n[API]"
curl -s http://localhost:4567/status || echo "API non disponible"

echo -e "\n[SERVICES SYSTEMD]"
systemctl is-active roulotte-maintenance.service
systemctl is-active roulotte-syncgit.service

echo -e "\n[TIMERS]"
systemctl list-timers --all | grep roulotte || echo "Aucun timer"

echo -e "\n[DERNIERS LOGS]"
journalctl -u roulotte-maintenance.service -n 5 --no-pager
journalctl -u roulotte-syncgit.service -n 5 --no-pager

echo -e "\n[GIT]"
cd "$BASE_DIR"
git status -s

echo -e "\n[DERNIER RAPPORT]"
ls -1 "$BASE_DIR/reports" | tail -n 1

echo -e "\n==============================================="
echo "Dashboard mis à jour."
