# Release 1.1.0 — Stabilité & Automatisation
Date : 2026-04-10

Cette version 1.1.0 renforce la fiabilité, l’automatisation et la cohérence de l’écosystème numérique de la Roulotte Solidaire Toulouse.

Elle améliore les outils de maintenance, l’API, les scripts de terrain et la documentation, afin de soutenir les actions quotidiennes sur le terrain.

---

## 🔧 Améliorations principales

### 1. Automatisation CRON
- Exécution automatique des scripts de maintenance
- Mode silencieux + logs dédiés
- Détection automatique des erreurs

### 2. API Ruby v1.1
- Nouveaux endpoints : `/reports`, `/status`, `/sync`
- Pagination simple
- Gestion d’erreurs renforcée
- Logs structurés améliorés

### 3. Intégration des rapports JSON
- Lecture automatique des rapports générés par les scripts
- Exposition via l’API
- Filtrage par date

### 4. Pack “La Route” — Mode hors‑ligne
- Cache météo
- Cache localisation
- Notes hors‑ligne
- Résilience améliorée

### 5. Documentation utilisateur
- Guide bénévole numérique
- Guide d’installation
- Guide des scripts

### 6. Script de synchronisation Git
- Push automatique
- Pull automatique
- Détection de conflits
- Logs dédiés

---

## 🧩 Correctifs
- Normalisation des chemins dans les scripts
- Amélioration de la robustesse des appels API
- Correction de bugs mineurs dans les outils Python

---

## 📦 Contenu ajouté
- `cron_maintenance.sh`
- `sync_git.sh`
- `api_v1.1.rb`
- Documentation utilisateur complète

---

## 🔜 Prochaine version : 1.2.0 — “Expérience & Accessibilité”
- Interface TUI Textual
- Dashboard HTML local
- API v2
- Notifications Telegram/Discord
- Documentation illustrée
- Mode démo
