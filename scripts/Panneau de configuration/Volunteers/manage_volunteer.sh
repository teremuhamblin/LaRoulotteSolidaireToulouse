#!/usr/bin/env bash
# ===========================================================
# Script : manage_volunteer.sh
# Objectif : Gérer les bénévoles (CRUD)
# ===========================================================

set -euo pipefail
IFS=$'\n\t'

FILE="volunteers.json"
[[ ! -f "$FILE" ]] && echo "[]" > "$FILE"

ACTION=""
ID=""
FIELD=""
VALUE=""
SEARCH=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --show) ACTION="show"; ID="$2"; shift 2 ;;
        --search) ACTION="search"; SEARCH="$2"; shift 2 ;;
        --update) ACTION="update"; ID="$2"; FIELD="$3"; VALUE="$4"; shift 4 ;;
        --delete) ACTION="delete"; ID="$2"; shift 2 ;;
        --export) ACTION="export"; ID="$2"; shift 2 ;;
        *) echo "Argument inconnu : $1"; exit 1 ;;
    esac
done

case "$ACTION" in
    show)
        jq ".[] | select(.id==\"$ID\")" "$FILE"
        ;;
    search)
        jq ".[] | select(.lastname | test(\"$SEARCH\"; \"i\"))" "$FILE"
        ;;
    update)
        jq "map(if .id==\"$ID\" then . + {\"$FIELD\": \"$VALUE\", updated_at: (now | todate)} else . end)" "$FILE" > tmp.json && mv tmp.json "$FILE"
        echo "Modification effectuée."
        ;;
    delete)
        jq "map(select(.id != \"$ID\"))" "$FILE" > tmp.json && mv tmp.json "$FILE"
        echo "Bénévole supprimé."
        ;;
    export)
        jq ".[] | select(.id==\"$ID\")" "$FILE" > "volunteer_$ID.json"
        echo "Export : volunteer_$ID.json"
        ;;
    *)
        echo "Aucune action valide fournie."
        exit 1
        ;;
esac
