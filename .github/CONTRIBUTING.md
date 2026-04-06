📄 CONTRIBUTING.md
> La Roulotte Solidaire Toulouse

🤝 Contribuer à La Roulotte Solidaire Toulouse
Merci de vouloir participer à ce projet citoyen, humain et ouvert.

Ce document explique comment contribuer, comment collaborer, et comment maintenir la qualité du projet.  
Il s’adresse aux bénévoles, contributeurs, rédacteurs, designers, organisateurs et citoyens souhaitant aider.

---

🧭 1. Principes fondamentaux

> La Roulotte Solidaire Toulouse repose sur trois piliers :  
> Respect — Transparence — Solidarité

Toute contribution doit respecter :

- la dignité des personnes rencontrées  
- la confidentialité des situations personnelles  
- la neutralité politique, religieuse et idéologique  
- la bienveillance envers les bénévoles et contributeurs  
- la sécurité de tous  

Pour plus de détails, consultez :  
👉 CODEOFCONDUCT.md

---

🛠️ 2. Types de contributions possibles

Vous pouvez contribuer de nombreuses manières :

🔹 Documentation
- Rédaction ou amélioration des guides  
- Mise à jour des procédures  
- Ajout de fiches pratiques  
- Correction orthographique ou structurelle  

🔹 Organisation & logistique
- Propositions d’amélioration des actions  
- Gestion du matériel  
- Optimisation des collectes  
- Création d’outils internes simples  

🔹 Communication & visuels
- Création de visuels, affiches, flyers  
- Mise à jour du dossier MULTIMÉDIA  
- Aide aux réseaux sociaux  
- Création de logos ou bannières  

🔹 Dépôt GitHub
- Amélioration de l’arborescence  
- Ajout de templates  
- Amélioration du README ou de LaRST.md  
- Propositions de workflows simples  

---

📂 3. Structure du dépôt

`
.
├── LaRST.md              # Présentation complète du projet
├── README.md             # Présentation générale et vision
├── MULTIMÉDIA/           # Photos, vidéos, logos, visuels
├── docs/                 # Guides, procédures, affiches
├── actions/              # Comptes-rendus, bilans
├── scripts/              # Outils internes (optionnel)
└── .github/              # Templates, workflows
`

---

📝 4. Comment contribuer efficacement

✔️ Étape 1 — Ouvrir une issue
Avant toute modification importante :

- décrire clairement votre idée  
- expliquer pourquoi elle est utile  
- proposer une première piste  

Labels recommandés :
- documentation
- organisation
- visuel
- amélioration
- discussion

✔️ Étape 2 — Discuter ensemble
La Roulotte fonctionne de manière collaborative.  
Une issue permet d’échanger, d’ajuster et de valider l’idée.

✔️ Étape 3 — Créer une pull request
Une fois l’idée validée :

- créer une branche claire :  
  feature/nom-de-la-contribution
- rédiger une PR propre et concise  
- utiliser le template fourni  
- lier l’issue correspondante  

✔️ Étape 4 — Revue & validation
Les PR sont relues pour :

- cohérence  
- clarté  
- respect des valeurs  
- absence de données sensibles  
- qualité rédactionnelle  

---

🧼 5. Règles de qualité

✏️ Rédaction
- phrases courtes  
- ton neutre, bienveillant  
- pas de jargon inutile  
- pas de données personnelles  
- pas de photos identifiables sans consentement  

📁 Organisation
- respecter l’arborescence  
- nommer les fichiers clairement  
- éviter les doublons  
- privilégier les formats ouverts (PNG, JPG, PDF, MD)

🎨 Visuels & multimédia
- placer tous les visuels dans MULTIMÉDIA/  
- utiliser des noms explicites :  
  2024collecteaffiche_v1.png  
- ne jamais publier de visage sans accord écrit  

---

⚠️ 6. Ce qu’il ne faut pas faire

> ❌ Publier des informations personnelles  
> ❌ Ajouter des photos de personnes sans consentement  
> ❌ Modifier les valeurs ou la mission du projet  
> ❌ Ajouter du contenu politique, religieux ou polémique  
> ❌ Pousser des outils techniques inutiles  
> ❌ Imposer une direction sans discussion préalable  

---

🧩 7. Ressources utiles

- LaRST.md — cœur du projet  
- README.md — vision et organisation  
- CODEOFCONDUCT.md — règles de respect  
- MULTIMÉDIA/ — visuels et communication  
- docs/ — guides et procédures  

---

🚀 8. Roadmap des contributions

Court terme
- structuration du dépôt  
- création de supports bénévoles  
- amélioration des visuels  

Moyen terme
- création d’un site web  
- documentation avancée  
- optimisation des collectes  

Long terme
- modèle reproductible pour d’autres villes  
- documentation complète open-source  

---

❤️ 9. Merci

Merci à toutes celles et ceux qui contribuent, écrivent, organisent, créent, partagent ou soutiennent.  
La solidarité est un mouvement collectif — chaque geste compte.

> “On ne fait pas de grandes choses, mais de petites choses avec un grand cœur.”
`

---

Annonce de lancement de la milestone v1.2.0

Objet : Lancement de la version v1.2.0 — Observabilité, Dashboard TUI et Formulaires terrain

Bonjour à toutes et tous,  

La Roulotte passe en v1.2.0. Cette version se concentre sur observabilité, dashboard TUI et outils terrain (capture GPS/photo, formulaires, sync cloud). Nous ouvrons la milestone v1.2.0 et lançons le travail collaboratif : développement, CI, tests terrain et documentation.

---

Points clés de la version

- Objectif principal : fournir visibilité et retours rapides après installation (logs JSON, résumé post_install, alertes).  
- Livrables : module Observabilité, layout Zellij roulotte-dashboard, scripts Formulaires terrain, workflow CI --dry-run, hooks pre/post, docs et templates.  
- Critères de succès : CI --dry-run verte ; dashboard fonctionnel ; 3 tests terrain validés.

---

Roadmap et calendrier

Durée cible : 4 semaines  
Phases  
- Semaine 1 : Spécifications, backlog, maquette Zellij.  
- Semaine 2 : Développement module observabilité + hooks.  
- Semaine 3 : CI, lint, tests automatisés (--dry-run).  
- Semaine 4 : Tests terrain (3 volontaires), corrections, release candidate.

---

Actions immédiates et priorités

À faire maintenant
- Créer la milestone v1.2.0 et assigner les issues prioritaires (Observabilité, Dashboard, Formulaires, CI, Tests terrain, Docs).  
- Ajouter le workflow GitHub Actions ci-dryrun.yml (lint → shellcheck → dry-run) et protéger la branche main.  
- Installer le hook post_install pour générer le résumé JSON après installation.  
- Recruter 3 volontaires terrain pour tests (installation complète, capture GPS/photo, sync cloud).

Checklist rapide
- [ ] Milestone v1.2.0 créée  
- [ ] Issues créées et assignées  
- [ ] CI workflow ajouté et testé sur PR  
- [ ] post_install hook opérationnel  
- [ ] Dashboard Zellij validé localement  
- [ ] 3 tests terrain réalisés et retours collectés  
- [ ] Docs et RELEASE_NOTES prêts

---

Comment contribuer concrètement

Développement
- Prendre une issue dans la milestone et ouvrir une PR.  
- Exécuter shellcheck et ./scripts/mobile/installtermuxgodmode.sh --profile standard --dry-run --verbose localement avant PR.  
- Joindre les logs JSON/text en artifact sur la PR.

Tests terrain
- Suivre le plan de test fourni dans docs/tests/TERRAIN.md.  
- Remplir le formulaire de retour Markdown et attacher les logs et captures.

Documentation
- Mettre à jour docs/releases/1.2.0/RELEASE_NOTES.md et CHANGELOG.md pour chaque PR significative.

---

Commandes utiles (prêtes à coller)

Créer la milestone
`bash
gh milestone create v1.2.0 --due "$(date -d '+28 days' +%Y-%m-%d)" --description "Observabilité, Dashboard TUI, Formulaires terrain, CI dry-run"
`

Créer une issue exemple
`bash
gh issue create --title "Observabilité Module" --body "Implémenter collecte métriques d'installation et logs JSON. Acceptance: logs JSON dans ~/.local/share/roulotte-termux/logs, hook post_install extrait résumé." --milestone v1.2.0
`

Tester en local (dry-run)
`bash
bash scripts/mobile/installtermuxgodmode.sh --profile standard --dry-run --verbose > dryrun_output.txt 2>&1 || true
`

---

Réunions et coordination

- Réunion de kickoff : 30 minutes cette semaine pour valider backlog et assignations.  
- Standup hebdo : 15 minutes chaque lundi pour suivre l’avancement.  
- Canal de coordination : créer un thread dédié dans le canal projet (Slack/Matrix) pour retours terrain et alertes.

---

Contact et points de contact

- Responsable release : Teremu  
- Dev lead : @dev  
- Ops / tests terrain : @ops  
- Docs : @doc

Pour toute urgence ou blocage critique, poster dans le canal projet avec le tag [v1.2.0][URGENT].

---

Merci à toutes et tous pour votre engagement. Cette version va rendre nos installations beaucoup plus observables et nos retours terrain plus exploitables — c’est un grand pas pour la Roulotte. Je m’occupe de créer la milestone et les issues si tu veux, et je peux préparer le message d’annonce à envoyer par mail/Slack avec le lien vers la milestone.
