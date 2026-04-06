📄 README.md — Version 2.0.0

`md

La Roulotte Solidaire Toulouse — Version 2.0.0
Système opérationnel, modulaire et déployable pour la coordination, le suivi et l’observabilité des actions solidaires à Toulouse.

🎯 Mission
La Roulotte Solidaire Toulouse accompagne les personnes en grande précarité grâce à :
- des maraudes humaines et régulières,
- une écoute active,
- une distribution de biens essentiels,
- une orientation vers les structures adaptées.

La version 2.0.0 fournit un ensemble d’outils professionnels pour soutenir ces actions.

---

🚀 Fonctionnalités principales (v2.0.0)

🧩 Architecture 2.0 (modulaire & scalable)
- Modules indépendants  
- Plugins activables  
- Configuration centralisée  
- Support multi-profils (terrain, logistique, coordination)

🖥️ Dashboard TUI v3
- Vue multi-équipes  
- Vue stocks/dons améliorée  
- Vue interventions consolidée  
- Mode supervision pour la coordination

📝 Formulaires Terrain v2
- Fiches intervention, besoins, suivi, orientation  
- Validation automatique  
- Export JSON / CSV / PDF  
- Historique local + cloud

☁️ Sync Cloud v3
- Synchronisation bidirectionnelle  
- Gestion avancée des conflits  
- Mode offline complet  
- Chiffrement des données sensibles

🤖 Automatisation & CI/CD
- Tests automatisés  
- Vérification d’intégrité  
- Pipeline de déploiement  
- Génération automatique de rapports

---

📦 Installation

`bash
git clone https://github.com/<organisation>/roulotte.git
cd roulotte
./install.sh
`

Mode simulation (sans rien modifier) :

`bash
./install.sh --dry-run
`

---

🧪 Tests

Lancer tous les tests :

`bash
./scripts/tests/test_install.sh
`

Tester un module :

`bash
./scripts/tests/test_module.sh <module>
`

Dry-run :

`bash
./scripts/tests/testdryrun.sh
`

---

📚 Documentation

La documentation complète est disponible dans :

`
docs/
 ├── installation/
 ├── modules/
 ├── terrain/
 ├── dashboard/
 ├── sync/
 └── releases/2.0.0/
`

---

🛠️ Structure du projet

`
.
├── install.sh
├── modules/
├── dashboard/
├── forms/
├── sync/
├── scripts/
│   └── tests/
└── docs/
`

---

🤝 Contribution

Les contributions sont les bienvenues :
- ouverture d’issues,
- propositions d’amélioration,
- retours terrain,
- tests et rapports.

---

🏁 Licence
Projet ouvert et réutilisable dans un cadre solidaire et non lucratif.

---

❤️ Remerciements
Merci aux bénévoles, partenaires et personnes accompagnées qui rendent ce projet vivant et utile.
`

---
