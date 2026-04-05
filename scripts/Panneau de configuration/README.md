🛠️ panneaudeconfiguration/
La Roulotte Solidaire Toulouse

Ce dossier regroupe le Panneau de Configuration interne de La Roulotte Solidaire Toulouse.  
Il centralise tous les outils permettant de créer, gérer, modifier et administrer les données essentielles du projet : bénévoles et bénéficiaires.

Ce panneau constitue la base du futur dashboard, de l’API interne et des outils CLI/TUI.

---

🎯 Objectifs du panneau de configuration

- offrir un espace clair pour administrer les bénévoles  
- permettre la gestion complète des bénéficiaires  
- centraliser les scripts de création, modification, suppression et consultation  
- garantir une structure cohérente, modulaire et évolutive  
- servir de fondation pour un futur panneau web ou interface terminal  

---

🗂️ Structure du dossier

`plaintext
panneaudeconfiguration/
│
├── README.md
│
├── volunteers/
│   ├── create/
│   │   ├── add_volunteer.sh        # Création d’un bénévole
│   │   └── validate_volunteer.sh   # Vérification des données
│   │
│   └── manage/
│       ├── list_volunteers.sh      # Liste complète
│       ├── edit_volunteer.sh       # Modification
│       ├── delete_volunteer.sh     # Suppression
│       └── search_volunteer.sh     # Recherche avancée
│
├── beneficiary/
│   ├── create/
│   │   ├── add_beneficiary.sh      # Création d’un bénéficiaire
│   │   └── validate_beneficiary.sh # Vérification des données
│   │
│   └── manage/
│       ├── list_beneficiaries.sh   # Liste complète
│       ├── edit_beneficiary.sh     # Modification
│       ├── delete_beneficiary.sh   # Suppression
│       └── search_beneficiary.sh   # Recherche avancée
│
└── modules/
    ├── logs.sh                     # Système de logs unifié
    ├── validation.sh               # Fonctions de validation
    ├── json.sh                     # Manipulation JSON
    └── api.sh                      # Connexion API interne
`

---

🧩 Fonctionnement général

✔️ Création (create/)
Les scripts de création permettent d’ajouter un bénévole ou un bénéficiaire via :  
- saisie interactive  
- import JSON  
- appel API interne  

Chaque création passe par :  
- une validation stricte  
- un log horodaté  
- un enregistrement JSON  

---

✔️ Gestion (manage/)
Les scripts de gestion permettent :  
- la consultation (liste, recherche)  
- la modification (édition sécurisée)  
- la suppression (avec confirmation)  
- l’export des données  

Tous les scripts utilisent les modules communs pour garantir :  
- cohérence  
- sécurité  
- traçabilité  

---

🚀 Utilisation

Ajouter un bénévole
`bash
./panneaudeconfiguration/volunteers/create/add_volunteer.sh
`

Modifier un bénéficiaire
`bash
./panneaudeconfiguration/beneficiary/manage/edit_beneficiary.sh
`

Lister tous les bénévoles
`bash
./panneaudeconfiguration/volunteers/manage/list_volunteers.sh
`

---

🔒 Standards techniques

- set -euo pipefail dans tous les scripts  
- logs normalisés : INFO / WARN / ERROR  
- validation stricte des champs (nom, téléphone, statut…)  
- aucune donnée sensible dans les logs  
- structure JSON propre et stable  

---

📌 Évolutions prévues

- intégration complète avec l’API interne  
- ajout d’une TUI (interface terminal) pour les responsables  
- panneau web administrateur (React / Svelte / Flask / FastAPI)  
- système de permissions (admin / staff / bénévole)  

---
