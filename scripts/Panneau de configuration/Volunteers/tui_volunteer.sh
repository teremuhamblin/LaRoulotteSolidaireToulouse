#!/usr/bin/env bash

DIALOG=${DIALOG=dialog}

while true; do
  CHOICE=$($DIALOG --clear --stdout \
    --title "Gestion des bénévoles" \
    --menu "Choisissez une action :" 15 60 6 \
    1 "Créer un bénévole" \
    2 "Gérer les bénévoles" \
    3 "Quitter")

  case "$CHOICE" in
    1) ./create_volunteer.sh ;;
    2) ./manage_volunteer.sh ;;
    3) clear; exit 0 ;;
  esac
done
