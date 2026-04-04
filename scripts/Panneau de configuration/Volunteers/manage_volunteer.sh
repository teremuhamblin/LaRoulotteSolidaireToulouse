#!/usr/bin/env bash
# ===========================================================
# Script : manage_volunteer.sh
# Objectif : Gestion complète des bénévoles via menu avancé
# Auteur : La Roulotte Solidaire Toulouse
# Version : 2.0.0
# ===========================================================

set -euo pipefail
IFS=$'\n\t'

RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; BLUE="\e[34m"; CYAN="\e[36m"; RESET="\e[0m"

FILE="volunteers.json"
[[ ! -f "$FILE" ]] && echo "[]" > "$FILE"

log() { echo -e "$(date '+%Y-%m-%d %H:%M:%S') — $1 — $2" | tee -a manage_volunteer.log; }
info() { log "${GREEN}INFO${RESET}" "$1"; }
warn() { log "${YELLOW}WARN${RESET}" "$1"; }
error() { log "${RED}ERROR${RESET}" "$1"; }

loading() {
    echo -ne "${CYAN}Chargement"
    for i in {1..3}; do echo -ne "."; sleep 0.3; done
    echo -e "${RESET}"
}

# -----------------------------------------------------------
# Fonctions CRUD
# -----------------------------------------------------------
show_volunteer() {
    clear
    read -rp "ID du bénévole : " ID
    jq ".[] | select(.id==\"$ID\")" "$FILE"
    read -rp "Entrée pour continuer..."
}

search_volunteer() {
    clear
    read -rp "Nom ou fragment : " NAME
    jq ".[] | select(.name | test(\"$NAME\"; \"i\"))" "$FILE"
    read -rp "Entrée pour continuer..."
}

update_volunteer() {
    clear
    read -rp "ID du bénévole : " ID
    read -rp "Champ à modifier (name/email/phone/role) : " FIELD
    read -rp "Nouvelle valeur : " VALUE

    jq "map(if .id==\"$ID\" then . + {\"$FIELD\": \"$VALUE\"} else . end)" "$FILE" > tmp.json && mv tmp.json "$FILE"

    info "Bénévole mis à jour : $ID"
    echo -e "${GREEN}Modification effectuée.${RESET}"
    read -rp "Entrée pour continuer..."
}

delete_volunteer() {
    clear
    read -rp "ID du bénévole à supprimer : " ID

    jq "map(select(.id != \"$ID\"))" "$FILE" > tmp.json && mv tmp.json "$FILE"

    info "Bénévole supprimé : $ID"
    echo -e "${RED}Bénévole supprimé.${RESET}"
    read -rp "Entrée pour continuer..."
}

export_volunteer() {
    clear
    read -rp "ID du bénévole : " ID
    jq ".[] | select(.id==\"$ID\")" "$FILE" > "volunteer_$ID.json"
    info "Export : volunteer_$ID.json"
    echo -e "${GREEN}Export effectué.${RESET}"
    read -rp "Entrée pour continuer..."
}

# -----------------------------------------------------------
# Menu principal
# -----------------------------------------------------------
menu() {
    while true; do
        clear
        echo -e "${BLUE}========= Gestion avancée des bénévoles =========${RESET}"
        echo -e "${GREEN}1.${RESET} Afficher un bénévole"
        echo -e "${GREEN}2.${RESET} Rechercher un bénévole"
        echo -e "${GREEN}3.${RESET} Modifier un bénévole"
        echo -e "${GREEN}4.${RESET} Supprimer un bénévole"
        echo -e "${GREEN}5.${RESET} Exporter un bénévole"
        echo -e "${GREEN}6.${RESET} Afficher tous les bénévoles"
        echo -e "${GREEN}7.${RESET} Quitter"
        echo ""
        read -rp "Votre choix : " CHOICE

        case "$CHOICE" in
            1) show_volunteer ;;
            2) search_volunteer ;;
            3) update_volunteer ;;
            4) delete_volunteer ;;
            5) export_volunteer ;;
            6) clear; jq '.' "$FILE"; read -rp "Entrée pour continuer..." ;;
            7) exit 0 ;;
            *) echo -e "${RED}Choix invalide.${RESET}"; sleep 1 ;;
        esac
    done
}

menu
