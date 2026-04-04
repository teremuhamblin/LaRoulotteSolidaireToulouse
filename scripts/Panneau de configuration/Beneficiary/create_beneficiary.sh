#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

FILE="beneficiaries.json"
[[ ! -f "$FILE" ]] && echo "[]" > "$FILE"

LASTNAME=""
FIRSTNAME=""
NICKNAME=""
PHONE=""
NEED=""
LOCATION=""
NOTES=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --lastname) LASTNAME="$2"; shift 2 ;;
        --firstname) FIRSTNAME="$2"; shift 2 ;;
        --nickname) NICKNAME="$2"; shift 2 ;;
        --phone) PHONE="$2"; shift 2 ;;
        --need) NEED="$2"; shift 2 ;;
        --location) LOCATION="$2"; shift 2 ;;
        --notes) NOTES="$2"; shift 2 ;;
        *) echo "Argument inconnu : $1"; exit 1 ;;
    esac
done

[[ -z "$LASTNAME" || -z "$FIRSTNAME" ]] && {
    echo "Erreur : nom et prénom obligatoires."
    exit 1
}

ID=$(uuidgen)

JSON=$(jq -n \
    --arg id "$ID" \
    --arg lastname "$LASTNAME" \
    --arg firstname "$FIRSTNAME" \
    --arg nickname "$NICKNAME" \
    --arg phone "$PHONE" \
    --arg need "$NEED" \
    --arg location "$LOCATION" \
    --arg notes "$NOTES" \
    '{id:$id, lastname:$lastname, firstname:$firstname, nickname:$nickname, phone:$phone, need:$need, location:$location, notes:$notes, created_at: now | todate}')

jq ". += [$JSON]" "$FILE" > tmp.json && mv tmp.json "$FILE"

echo "Bénéficiaire créé : $FIRSTNAME $LASTNAME (ID : $ID)"
