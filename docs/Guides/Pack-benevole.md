🟦 3) Pack documentation bénévoles

Je te crée 3 fichiers essentiels :

---

📘 3.1 — Guide bénévole
📍 Chemin :  
`
docs/guides/guide_benevole.md
`

`markdown

Guide Bénévole — La Roulotte Solidaire Toulouse

Bienvenue dans l’équipe !  
Ce guide explique comment utiliser les outils numériques de la Roulotte.

1. Les outils essentiels
- Pack “La Route”
- Scripts de maintenance
- API interne
- Dashboard CLI

2. Utilisation du pack “La Route”
- Météo
- GPS
- Notes
- Mode hors-ligne

3. Maintenance quotidienne
La maintenance est automatique, mais peut être lancée manuellement :

`
bash scripts/maintenance/maintenance_roulotte.sh
`

4. Où trouver les rapports ?
`
/reports/
`

5. En cas de problème
- Vérifier le dashboard : bash scripts/diagnostics/dashboard.sh
- Contacter un référent technique
`

---

📘 3.2 — Guide installation
📍 Chemin :  
`
docs/guides/installation.md
`

`markdown

Installation — La Roulotte Solidaire Toulouse

1. Prérequis
- Linux Mint ou Termux Android
- Git
- Python 3
- Ruby + Sinatra

2. Cloner le projet
`
git clone https://github.com/roulotte/roulotte.git (github.com in Bing)
`

3. Installer les services systemd
`
bash scripts/systemd/installsystemdservices.sh
`

4. Vérifier l’installation
`
bash scripts/systemd/checksystemdstatus.sh
`

5. Lancer l’API
`
ruby scripts/API/app.rb
`
`

---

📘 3.3 — Guide scripts
📍 Chemin :  
`
docs/guides/scripts.md
`

`markdown

Guide des Scripts — La Roulotte Solidaire Toulouse

Scripts maintenance
- maintenance_roulotte.sh
- maintenance_report.py
- cron_maintenance.sh
- sync_git.sh

Scripts diagnostics
- full_diagnostic.sh
- dashboard.sh

Scripts systemd
- installsystemdservices.sh
- checksystemdstatus.sh
- restartsystemdservices.sh
- uninstallsystemdservices.sh

Scripts Termux
- termux_maintenance.sh
- termuxsyncgit.sh

Chaque script est documenté dans son README dédié.
`

---

🟦 Résumé des fichiers créés

| Fichier | Chemin |
|--------|--------|
| fulldiagnostic.sh | scripts/diagnostics/fulldiagnostic.sh |
| dashboard.sh | scripts/diagnostics/dashboard.sh |
| guidebenevole.md | docs/guides/guidebenevole.md |
| installation.md | docs/guides/installation.md |
| scripts.md | docs/guides/scripts.md |

---
