#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
create_admin_and_setup.py
Crée le compte administrateur LaRST-Admin avec mot de passe @LaRST si absent.
Usage: sudo python3 create_admin_and_setup.py
"""

import os
import subprocess
import sys

ADMIN_USER = "LaRST-Admin"
ADMIN_PASS = "@LaRST"
HOME_DIR = f"/home/{ADMIN_USER}"

def run(cmd):
    res = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    return res.returncode, res.stdout.strip(), res.stderr.strip()

def user_exists(username):
    return run(f"id -u {username}")[0] == 0

def create_admin():
    if user_exists(ADMIN_USER):
        print(f"[i] L'utilisateur {ADMIN_USER} existe déjà.")
        return
    print(f"[+] Création de l'utilisateur {ADMIN_USER} ...")
    # create user with home and bash
    code, out, err = run(f"useradd -m -s /bin/bash -c 'La Roulotte Solidaire Toulouse Admin' {ADMIN_USER}")
    if code != 0:
        print("Erreur useradd:", err)
        sys.exit(1)
    # set password
    code, out, err = run(f"echo \"{ADMIN_USER}:{ADMIN_PASS}\" | chpasswd")
    if code != 0:
        print("Erreur chpasswd:", err)
        sys.exit(1)
    # add to sudo
    code, out, err = run(f"usermod -aG sudo {ADMIN_USER}")
    if code != 0:
        print("Erreur usermod:", err)
        sys.exit(1)
    print(f"[+] Utilisateur {ADMIN_USER} créé avec mot de passe par défaut. Changez le mot de passe immédiatement.")
    print(f"    sudo passwd {ADMIN_USER}")

if __name__ == "__main__":
    if os.geteuid() != 0:
        print("Ce script doit être exécuté en root (sudo).")
        sys.exit(1)
    create_admin()
