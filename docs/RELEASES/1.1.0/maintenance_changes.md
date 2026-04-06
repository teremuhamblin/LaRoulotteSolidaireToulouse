# Changements Maintenance — Version 1.1.0

## Objectif
Automatiser la maintenance quotidienne et améliorer la fiabilité des scripts utilisés par la Roulotte Solidaire Toulouse.

---

## 🔧 Automatisation CRON
- Ajout d’un script dédié : `cron_maintenance.sh`
- Exécution silencieuse quotidienne.
- Logs séparés : `logs/cron/cron_YYYYMMDD.log`
- Détection automatique des erreurs :
  - absence de rapport
  - permissions incorrectes
  - erreurs Python/Bash

---

## 🛠️ Améliorations du script Bash `maintenance_roulotte.sh`
- Normalisation des chemins (`$DATA_DIR`, `$LOG_DIR`).
- Gestion d’erreurs renforcée (exit codes + messages).
- Mode `--cron` optimisé.
- Nettoyage automatique des anciens logs.
- Ajout d’un rapport JSON plus complet.

---

## 🐍 Améliorations du script Python `maintenance_report.py`
- Validation des données avant écriture.
- Ajout d’un champ `system_status`.
- Compatibilité API v1.1.
- Gestion hors‑ligne améliorée.

---

## 📌 Nouveaux fichiers
- `scripts/maintenance/cron_maintenance.sh`
- `logs/cron/` (nouveau dossier)

---

## 🧪 Tests
- Tests sur Termux (Android 10).
- Tests sur Linux Mint.
- Simulation CRON locale.
