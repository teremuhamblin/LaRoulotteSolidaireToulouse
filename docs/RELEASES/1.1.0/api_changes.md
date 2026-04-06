# Changements API — Version 1.1.0

## Objectif
Renforcer la stabilité, la lisibilité et l’automatisation de l’API Ruby utilisée par les scripts de maintenance et les outils terrain.

---

## 🔧 Nouveaux endpoints

### `/reports`
- Retourne la liste des rapports JSON générés par les scripts.
- Filtrage par date (`?date=YYYY-MM-DD`).
- Format JSON strict (via OJ).

### `/status`
- Indique l’état du système (OK / WARNING / ERROR).
- Vérifie : accès disque, présence des rapports, état des scripts.

### `/sync`
- Déclenche une synchronisation Git locale.
- Retourne un statut JSON détaillé.

---

## 🛠️ Améliorations internes
- Pagination simple ajoutée (`?page=` et `?limit=`).
- Gestion d’erreurs renforcée (codes HTTP cohérents).
- Logs structurés (format JSON).
- Sécurisation légère via token local.
- Refactorisation du routeur pour préparer la v2.

---

## 🧪 Tests & validation
- Tests manuels sur Termux + Linux Mint.
- Vérification des retours JSON.
- Validation des erreurs HTTP.

---

## 📌 Notes
Cette version prépare la transition vers **API v2** (auth renforcée + filtres avancés).
