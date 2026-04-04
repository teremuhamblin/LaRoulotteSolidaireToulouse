- ##### README.md 
- Site Web OPEN-SOURCES

---

# SITE WEB
- `La Roulotte Solidaire Toulouse`
- Plateforme officielle d’information, de `coordination` et de `mobilisation citoyenne`.

---

### 📌 Présentation
> Le site web de La Roulotte Solidaire Toulouse a pour objectif de :
- présenter l’association, ses valeurs et ses actions
- faciliter l’accès aux informations pour les bénévoles et les bénéficiaires
- centraliser les ressources (guides, documents, procédures)
- permettre la gestion des tournées, des stocks et des bénévoles
- renforcer la visibilité et la transparence de nos actions solidaires

Ce site est conçu pour être léger, accessible, responsive, et utilisable sur le terrain.

---

### 🏗️ Architecture du site
- Le site repose sur une structure simple, claire et évolutive :

`
/site
 ├── index.html
 ├── pages/
 │    ├── association.html
 │    ├── benevoles.html
 │    ├── beneficiaires.html
 │    ├── tournées.html
 │    ├── contact.html
 │    └── mentions-legales.html
 ├── assets/
 │    ├── css/
 │    ├── js/
 │    ├── img/
 │    └── icons/
 ├── api/
 │    ├── volunteers/
 │    ├── beneficiaries/
 │    └── tours/
 └── README.md
`

---

### 🎨 Identité visuelle
- Palette : couleurs douces, chaleureuses, inspirées du terrain  
- Typographies lisibles et accessibles  
- Icônes simples et universelles  
- Design responsive (mobile-first)

---

### 🛠️ Technologies utilisées
- HTML5 / CSS3 — structure et style  
- JavaScript — interactions et formulaires  
- JSON — stockage léger des données locales  
- API interne (optionnel) — gestion avancée des bénévoles, bénéficiaires et tournées  
- Bash / Python — scripts d’automatisation (gestion bénévoles, bénéficiaires, stocks)

---

### 🚀 Fonctionnalités principales

👥 Gestion des bénévoles
- création de compte  
- mise à jour des informations  
- rôles et permissions  
- historique des participations  

### ❤️ Gestion des bénéficiaires
- création de dossier complet  
- informations personnelles  
- besoins spécifiques  
- suivi des distributions  
- confidentialité renforcée  

### 🚚 Gestion des tournées
- planification  
- affectation des bénévoles  
- suivi des stocks  
- rapports automatiques  

### 📚 Documentation intégrée
- guides bénévoles  
- guides bénéficiaires  
- procédures internes  
- documents téléchargeables  

---

### 🔐 Sécurité & confidentialité
- aucune donnée sensible stockée sans chiffrement  
- séparation claire entre données publiques et privées  
- conformité RGPD  
- logs sécurisés  
- permissions par rôle (admin / responsable / bénévole)

---

### 🧩 Scripts associés
Le site peut être enrichi par des scripts Bash/Python :

- create_volunteer.sh  
- manage_volunteer.sh  
- create_beneficiary.sh  
- manage_beneficiary.sh  
- sync_site.sh (déploiement)  
- validate_json.sh (contrôle qualité)

---

### 🧪 Tests & validation
- validation HTML/CSS  
- tests de formulaires  
- vérification des JSON  
- tests d’accessibilité (WCAG)  
- tests mobiles (Android / iOS)

---

### 🚀 Déploiement
Le site peut être déployé via :
- GitHub Pages  
- un serveur mutualisé  
- un VPS léger  
- un conteneur Docker (optionnel)

Commande de déploiement (exemple) :
`
bash scripts/sync_site.sh
`

---

### 🤝 Contribution
Toute contribution est la bienvenue :
- amélioration du design  
- ajout de pages  
- optimisation du code  
- traduction  
- documentation  

Merci de suivre les conventions du dépôt :
- commits clairs  
- PR structurées  
- respect des guides internes  

---

### 📄 Licence
Projet sous licence MIT (modifiable selon tes besoins).

---

##📬 Contact
- 📧 `contact[DOMAIN.FR]` 
- 📍 `Toulouse, France`  
- 🌐 `https://laroulottesolidaire.fr`
`

---
