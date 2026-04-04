#!/usr/bin/env bash
# ===========================================================
# Script : create_volunteer.sh
# Objectif : Créer un bénévole via un menu interactif avancé
# Auteur : La Roulotte Solidaire Toulouse
# Version : 2.0.0
# ===========================================================

set -euo pipefail
IFS=$'\n\t'

# -----------------------------------------------------------
# Couleurs
# -----------------------------------------------------------
RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; BLUE="\e[34m"; CYAN="\e[36m"; RESET="\e[0m"

# -----------------------------------------------------------
# Logging
# -----------------------------------------------------------
log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') — $1 — $2" | tee -a create_volunteer.log
}

info() { log "${GREEN}INFO${RESET}" "$1"; }
warn() { log "${YELLOW}WARN${RESET}" "$1"; }
error() { log "${RED}ERROR${RESET}" "$1"; }

# -----------------------------------------------------------
# Dépendances
# -----------------------------------------------------------
check_dependencies() {
    local deps=("jq" "uuidgen")
    for dep in "${deps[@]}"; do
        command -v "$dep" >/dev/null 2>&1 || { error "Dépendance manquante : $dep"; exit 1; }
    done
}

# -----------------------------------------------------------
# Validation email
# -----------------------------------------------------------
validate_email() {
    [[ "$1" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]
}

# -----------------------------------------------------------
# Animation
# -----------------------------------------------------------
loading() {
    echo -ne "${CYAN}Traitement en cours"
    for i in {1..3}; do
        echo -ne "."
        sleep 0.3
    done
    echo -e "${RESET}"
}

# -----------------------------------------------------------
# Création bénévole
# -----------------------------------------------------------
create_volunteer() {
    clear
    echo -e "${BLUE}=== Création d’un nouveau bénévole ===${RESET}"

    read -rp "Nom complet : " NAME
    read -rp "Email : " EMAIL
    read -rp "Téléphone (optionnel) : " PHONE
    read -rp "Rôle (ex : maraude, logistique, cuisine) : " ROLE

    if ! validate_email "$EMAIL"; then
        error "Email invalide."
        exit 1
    fi

    local id
    id=$(uuidgen)

    local file="volunteers.json"
    [[ ! -f "$file" ]] && echo "[]" > "$file"

    local json
    json=$(jq -n \
        --arg id "$id" \
        --arg name "$NAME" \
        --arg email "$EMAIL" \
        --arg phone "$PHONE" \
        --arg role "$ROLE" \
        '{id:$id, name:$name, email:$email, phone:$phone, role:$role, created_at: now | todate}')

    loading

    jq ". += [$json]" "$file" > tmp.json && mv tmp.json "$file"

    info "Bénévole créé : $NAME ($id)"
    echo -e "${GREEN}Bénévole ajouté avec succès !${RESET}"
    read -rp "Appuyez sur Entrée pour revenir au menu..."
}

# -----------------------------------------------------------
# Menu interactif
# -----------------------------------------------------------
menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${RESET}"
        echo -e "${CYAN}     MENU — Gestion des bénévoles        ${RESET}"
        echo -e "${CYAN}=========================================${RESET}"
        echo -e "${GREEN}1.${RESET} Créer un bénévole"
        echo -e "${GREEN}2.${RESET} Afficher la liste des bénévoles"
        echo -e "${GREEN}3.${RESET} Quitter"
        echo ""
        read -rp "Votre choix : " CHOICE

        case "$CHOICE" in
            1) create_volunteer ;;
            2) clear; jq '.' volunteers.json; read -rp "Entrée pour revenir..." ;;
            3) exit 0 ;;
            *) echo -e "${RED}Choix invalide.${RESET}"; sleep 1 ;;
        esac
    done
}

# -----------------------------------------------------------
# Exécution
# -----------------------------------------------------------
check_dependencies
menu
