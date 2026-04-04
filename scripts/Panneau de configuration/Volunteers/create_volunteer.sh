#!/usr/bin/env bash
# ===========================================================
# Script : create_volunteer.sh
# Objectif : Créer un bénévole
# ===========================================================

set -euo pipefail
IFS=$'\n\t'

FILE="volunteers.json"
[[ ! -f "$FILE" ]] && echo "[]" > "$FILE"

LASTNAME=""
FIRSTNAME=""
EMAIL=""
PHONE=""
ROLE=""
AVAILABILITY=""
NOTES=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --lastname) LASTNAME="$2"; shift 2 ;;
        --firstname) FIRSTNAME="$2"; shift 2 ;;
        --email) EMAIL="$2"; shift 2 ;;
        --phone) PHONE="$2"; shift 2 ;;
        --role) ROLE="$2"; shift 2 ;;
        --availability) AVAILABILITY="$2"; shift 2 ;;
        --notes) NOTES="$2"; shift 2 ;;
        *) echo "Argument inconnu : $1"; exit 1 ;;
    esac
done

[[ -z "$LASTNAME" || -z "$FIRSTNAME" || -z "$ROLE" ]] && {
    echo "Erreur : nom, prénom et rôle sont obligatoires."
    exit 1
}

ID=$(uuidgen)

JSON=$(jq -n \
    --arg id "$ID" \
    --arg lastname "$LASTNAME" \
    --arg firstname "$FIRSTNAME" \
    --arg email "$EMAIL" \
    --arg phone "$PHONE" \
    --arg role "$ROLE" \
    --arg availability "$AVAILABILITY" \
    --arg notes "$NOTES" \
    '{id:$id, lastname:$lastname, firstname:$firstname, email:$email, phone:$phone, role:$role, availability:$availability, notes:$notes, created_at: now | todate}')

jq ". += [$JSON]" "$FILE" > tmp.json && mv tmp.json "$FILE"

echo "Bénévole créé : $FIRSTNAME $LASTNAME (ID : $ID)"
