⚙️ Automatisation
Scripts d’Automatisation
La Roulotte Solidaire Toulouse

Ce dossier regroupe l’ensemble des scripts d’automatisation utilisés pour orchestrer, fiabiliser et accélérer les opérations internes de La Roulotte Solidaire Toulouse.  
Ces scripts permettent de réduire les tâches répétitives, d’éviter les erreurs humaines et d’assurer une gestion fluide des actions, des données et des outils.

---

🎯 Objectifs du dossier

Les scripts d’automatisation servent à :

- automatiser les tâches récurrentes (exports, imports, nettoyages, synchronisations)  
- orchestrer les processus internes (gestion bénévoles, bénéficiaires, maraudes…)  
- garantir une exécution fiable, reproductible et traçable  
- fournir une base solide pour les futurs outils CLI, TUI ou API  
- centraliser les workflows techniques pour les responsables opérationnels  

---

🗂️ Structure recommandée

`plaintext
automatisation/
│
├── README.md                    # Documentation du dossier
│
├── taches/                      # Automatisations unitaires
│   ├── sync_benevoles.sh        # Synchronisation des données bénévoles
│   ├── sync_beneficiaires.sh    # Mise à jour des bénéficiaires
│   ├── nettoyage_donnees.sh     # Nettoyage et normalisation
│   ├── export_quotidien.sh      # Export automatique (CSV/JSON)
│   └── sauvegarde.sh            # Sauvegardes planifiées
│
├── workflows/                   # Automatisations complexes / pipelines
│   ├── pipeline_maraude.sh      # Préparation complète d’une maraude
│   ├── pipeline_distribution.sh # Préparation d’une distribution alimentaire
│   └── pipeline_reporting.sh    # Génération de rapports automatiques
│
├── cron/                        # Tâches planifiées
│   ├── cron_daily.sh            # Routine quotidienne
│   ├── cron_weekly.sh           # Routine hebdomadaire
│   └── cron_monthly.sh          # Routine mensuelle
│
└── modules/                     # Fonctions partagées
    ├── logs.sh                  # Système de logs unifié
    ├── api.sh                   # Appels API internes
    ├── json.sh                  # Manipulation JSON
    ├── validation.sh            # Vérification des entrées
    └── outils.sh                # Fonctions utilitaires
`

---

🧩 Standards techniques

Tous les scripts suivent les règles suivantes :

🔒 Robustesse
- set -euo pipefail activé  
- gestion d’erreurs centralisée  
- logs normalisés (INFO / WARN / ERROR)  
- horodatage systématique  

🧼 Lisibilité & Accessibilité
- messages clairs pour les bénévoles  
- commentaires pédagogiques  
- noms explicites et cohérents  

🧱 Modulaire & Réutilisable
- aucune duplication de code  
- modules partagés dans modules/  
- pipelines composés de tâches unitaires  

---

🚀 Utilisation

Lancer une tâche unitaire
`bash
./automatisation/taches/export_quotidien.sh
`

Lancer un pipeline complet
`bash
./automatisation/workflows/pipeline_maraude.sh
`

Exécuter une routine planifiée
`bash
./automatisation/cron/cron_daily.sh
`

---

📡 Intégration API

Les scripts peuvent interagir avec l’API interne via :

`bash
api_get "/beneficiaires/liste"
api_post "/benevoles/ajout" '{"nom":"Dupont"}'
`

---

🛡️ Sécurité & Données

- aucune donnée sensible dans les logs  
- exports anonymisés par défaut  
- validation stricte des entrées  
- sauvegardes horodatées et vérifiées  

---

📌 Évolutions prévues

- intégration GitHub Actions pour automatisations CI/CD  
- ajout d’un système de tests automatisés  
- création d’une TUI pour lancer les automatisations depuis le terminal  
- documentation interactive (mkdocs ou docs/)  

---
