#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
user_manager_tui.py
TUI avancée pour gestion des comptes (Textual + Rich)
Usage: sudo python3 user_manager_tui.py
"""

import os
import sys
import csv
import pwd
import grp
import subprocess
import logging
from datetime import datetime
from typing import List, Dict, Optional

# Textual / Rich imports
from rich.table import Table
from rich.panel import Panel
from rich.text import Text
from rich.console import RenderableType
from textual.app import App, ComposeResult
from textual.widgets import Header, Footer, Static, Button, Input, DataTable, Label
from textual.containers import Horizontal, Vertical, VerticalScroll
from textual.reactive import reactive
from textual.message import Message
from textual import events

LOGFILE = "/var/log/roulotte_user_manager.log"

# ---------- Logging ----------
def setup_logging():
    try:
        logging.basicConfig(
            filename=LOGFILE,
            level=logging.INFO,
            format="%(asctime)s %(levelname)s: %(message)s",
        )
    except PermissionError:
        logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s: %(message)s")
        print("Impossible d'écrire le fichier de log. Lancez en root pour activer la journalisation.")

def log(action, detail=""):
    logging.info("%s %s", action, detail)

# ---------- System helpers ----------
def run_cmd(cmd: str, capture: bool = True):
    res = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE if capture else None,
                         stderr=subprocess.PIPE if capture else None, text=True)
    out = res.stdout.strip() if res.stdout else ""
    err = res.stderr.strip() if res.stderr else ""
    return res.returncode, out, err

def list_users() -> List[Dict]:
    users = []
    for p in pwd.getpwall():
        if p.pw_uid >= 1000 or p.pw_uid == 0:
            groups = [g.gr_name for g in grp.getgrall() if p.pw_name in g.gr_mem]
            users.append({
                "username": p.pw_name,
                "uid": p.pw_uid,
                "gid": p.pw_gid,
                "home": p.pw_dir,
                "shell": p.pw_shell,
                "gecos": p.pw_gecos,
                "groups": ",".join(groups)
            })
    return sorted(users, key=lambda x: x["username"])

def user_exists(username: str) -> bool:
    try:
        pwd.getpwnam(username)
        return True
    except KeyError:
        return False

# ---------- User operations ----------
def create_user(username: str, full_name: Optional[str], password: Optional[str],
                shell: str = "/bin/bash", add_sudo: bool = False) -> (bool, str):
    if user_exists(username):
        return False, "Utilisateur existe déjà"
    cmd = f"useradd -m -s {shell} "
    if full_name:
        cmd += f"-c \"{full_name}\" "
    cmd += username
    code, out, err = run_cmd(cmd)
    if code != 0:
        return False, err or "Erreur useradd"
    if password:
        code, out, err = run_cmd(f"echo \"{username}:{password}\" | chpasswd")
        if code != 0:
            # rollback
            run_cmd(f"deluser --remove-home {username}")
            return False, err or "Erreur chpasswd"
    else:
        # no password set: lock account until password set
        run_cmd(f"passwd -l {username}")
    if add_sudo:
        run_cmd(f"usermod -aG sudo {username}")
    log("CREATE_USER", f"{username} full_name={full_name} shell={shell} sudo={add_sudo}")
    return True, "Utilisateur créé"

def delete_user(username: str, remove_home: bool = False) -> (bool, str):
    if not user_exists(username):
        return False, "Utilisateur introuvable"
    cmd = f"deluser {'--remove-home' if remove_home else ''} {username}"
    code, out, err = run_cmd(cmd)
    if code != 0:
        return False, err or "Erreur suppression"
    log("DELETE_USER", f"{username} remove_home={remove_home}")
    return True, "Utilisateur supprimé"

def change_password(username: str, password: str) -> (bool, str):
    if not user_exists(username):
        return False, "Utilisateur introuvable"
    code, out, err = run_cmd(f"echo \"{username}:{password}\" | chpasswd")
    if code != 0:
        return False, err or "Erreur chpasswd"
    log("CHANGE_PASSWORD", username)
    return True, "Mot de passe changé"

def lock_user(username: str) -> (bool, str):
    if not user_exists(username):
        return False, "Utilisateur introuvable"
    run_cmd(f"usermod -L {username}")
    log("LOCK_USER", username)
    return True, "Compte verrouillé"

def unlock_user(username: str) -> (bool, str):
    if not user_exists(username):
        return False, "Utilisateur introuvable"
    run_cmd(f"usermod -U {username}")
    log("UNLOCK_USER", username)
    return True, "Compte déverrouillé"

def add_to_group(username: str, group: str) -> (bool, str):
    if not user_exists(username):
        return False, "Utilisateur introuvable"
    try:
        grp.getgrnam(group)
    except KeyError:
        return False, "Groupe introuvable"
    run_cmd(f"usermod -aG {group} {username}")
    log("ADD_TO_GROUP", f"{username} -> {group}")
    return True, "Ajout au groupe effectué"

def remove_from_group(username: str, group: str) -> (bool, str):
    if not user_exists(username):
        return False, "Utilisateur introuvable"
    try:
        g = grp.getgrnam(group)
    except KeyError:
        return False, "Groupe introuvable"
    members = [m for m in g.gr_mem if m != username]
    members_str = ",".join(members)
    run_cmd(f"gpasswd -M {members_str} {group}")
    log("REMOVE_FROM_GROUP", f"{username} -/-> {group}")
    return True, "Retrait du groupe effectué"

# ---------- CSV import ----------
def import_users_from_csv(path: str) -> List[Dict]:
    created = []
    errors = []
    with open(path, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            username = row.get("username", "").strip()
            if not username:
                errors.append((row, "username manquant"))
                continue
            full_name = row.get("full_name", "").strip() or None
            password = row.get("password", "").strip() or None
            sudo_flag = row.get("sudo", "").strip().lower() in ("yes", "y", "true", "1")
            shell = row.get("shell", "").strip() or "/bin/bash"
            ok, msg = create_user(username, full_name, password, shell, sudo_flag)
            if ok:
                created.append(username)
            else:
                errors.append((username, msg))
    return {"created": created, "errors": errors}

# ---------- Textual App ----------
class InfoPanel(Static):
    def update_info(self, text: str):
        self.update(Panel(Text(text, justify="left"), title="Infos"))

class UsersTable(Static):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.table = DataTable()
        self.table.add_columns("username", "uid", "home", "shell", "groups")
        self.refresh_table()

    def refresh_table(self):
        self.table.clear()
        for u in list_users():
            self.table.add_row(u["username"], str(u["uid"]), u["home"], u["shell"], u["groups"])
        self.update(self.table)

class ActionButton(Button):
    pass

class ConfirmDialog(Static):
    pass

class UserManagerApp(App):
    CSS_PATH = None
    BINDINGS = [("q", "quit", "Quitter"), ("r", "refresh", "Rafraîchir")]

    def __init__(self):
        super().__init__()
        self.info = None
        self.users_table = None

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True, tall=False)
        with Horizontal():
            with Vertical(id="left", classes="panel"):
                yield Static(Panel(Text("🚐 La Roulotte — Gestion des comptes", style="bold magenta"), title="Roulotte"), id="title")
                yield Button("Lister les utilisateurs", id="list_users")
                yield Button("Créer un utilisateur", id="create_user")
                yield Button("Supprimer un utilisateur", id="delete_user")
                yield Button("Changer mot de passe", id="change_password")
                yield Button("Verrouiller / Déverrouiller", id="lock_unlock")
                yield Button("Importer CSV", id="import_csv")
                yield Button("Créer admin LaRST-Admin", id="create_admin")
                yield Button("Afficher logs", id="show_logs")
                yield Button("Quitter", id="quit")
            with VerticalScroll(id="main", classes="panel"):
                self.users_table = UsersTable()
                yield self.users_table
                self.info = InfoPanel()
                yield self.info
        yield Footer()

    async def on_mount(self) -> None:
        setup_logging()
        log("START", "UserManager TUI démarré")
        self.info.update_info("Prêt. Utilise les boutons à gauche ou raccourcis (q pour quitter).")

    async def on_button_pressed(self, event: Button.Pressed) -> None:
        btn_id = event.button.id
        if btn_id == "list_users":
            self.users_table.refresh_table()
            self.info.update_info("Liste des utilisateurs rafraîchie.")
        elif btn_id == "create_user":
            await self.action_create_user()
        elif btn_id == "delete_user":
            await self.action_delete_user()
        elif btn_id == "change_password":
            await self.action_change_password()
        elif btn_id == "lock_unlock":
            await self.action_lock_unlock()
        elif btn_id == "import_csv":
            await self.action_import_csv()
        elif btn_id == "create_admin":
            await self.action_create_admin()
        elif btn_id == "show_logs":
            await self.action_show_logs()
        elif btn_id == "quit":
            await self.action_quit()

    async def action_create_user(self):
        # prompt in terminal (fallback) because Textual forms are verbose to implement here
        self.info.update_info("Assistant création utilisateur : bascule en mode terminal pour saisir les champs.")
        # temporarily suspend app to use input()
        await self.run_in_thread(self._create_user_interactive)

    def _create_user_interactive(self):
        # This runs in a thread to avoid blocking the UI event loop
        username = input("Nom d'utilisateur: ").strip()
        if not username:
            print("Annulé.")
            return
        full = input("Nom complet (optionnel): ").strip() or None
        pwd = input("Mot de passe (laisser vide pour verrouiller le compte): ").strip() or None
        sudo = input("Ajouter au groupe sudo ? (o/N): ").strip().lower().startswith("o")
        shell = input("Shell (par défaut /bin/bash): ").strip() or "/bin/bash"
        ok, msg = create_user(username, full, pwd, shell, sudo)
        print(msg)
        log("CREATE_USER_INTERACTIVE", f"{username} -> {msg}")

    async def action_delete_user(self):
        self.info.update_info("Suppression utilisateur : bascule en mode terminal.")
        await self.run_in_thread(self._delete_user_interactive)

    def _delete_user_interactive(self):
        username = input("Nom d'utilisateur à supprimer: ").strip()
        if not username:
            print("Annulé.")
            return
        remove_home = input("Supprimer le répertoire home ? (o/N): ").strip().lower().startswith("o")
        ok, msg = delete_user(username, remove_home)
        print(msg)
        log("DELETE_USER_INTERACTIVE", f"{username} -> {msg}")

    async def action_change_password(self):
        self.info.update_info("Changement mot de passe : bascule en mode terminal.")
        await self.run_in_thread(self._change_password_interactive)

    def _change_password_interactive(self):
        username = input("Nom d'utilisateur: ").strip()
        if not username:
            print("Annulé.")
            return
        pwd = input("Nouveau mot de passe: ").strip()
        ok, msg = change_password(username, pwd)
        print(msg)
        log("CHANGE_PASSWORD_INTERACTIVE", f"{username} -> {msg}")

    async def action_lock_unlock(self):
        self.info.update_info("Verrouiller/Déverrouiller : bascule en mode terminal.")
        await self.run_in_thread(self._lock_unlock_interactive)

    def _lock_unlock_interactive(self):
        username = input("Nom d'utilisateur: ").strip()
        if not username:
            print("Annulé.")
            return
        action = input("Verrouiller ou déverrouiller ? (v/d): ").strip().lower()
        if action == "v":
            ok, msg = lock_user(username)
        else:
            ok, msg = unlock_user(username)
        print(msg)
        log("LOCK_UNLOCK_INTERACTIVE", f"{username} -> {msg}")

    async def action_import_csv(self):
        self.info.update_info("Import CSV : bascule en mode terminal.")
        await self.run_in_thread(self._import_csv_interactive)

    def _import_csv_interactive(self):
        path = input("Chemin vers le fichier CSV: ").strip()
        if not path or not os.path.exists(path):
            print("Fichier introuvable.")
            return
        res = import_users_from_csv(path)
        print(f"Créés: {res['created']}")
        if res["errors"]:
            print("Erreurs:")
            for e in res["errors"]:
                print(e)
        log("IMPORT_CSV", f"{path} created={len(res['created'])} errors={len(res['errors'])}")

    async def action_create_admin(self):
        self.info.update_info("Création admin LaRST-Admin ...")
        await self.run_in_thread(self._create_admin_thread)

    def _create_admin_thread(self):
        # call the create_admin script logic inline
        ADMIN_USER = "LaRST-Admin"
        ADMIN_PASS = "@LaRST"
        if user_exists(ADMIN_USER):
            print(f"{ADMIN_USER} existe déjà.")
            return
        code, out, err = run_cmd(f"useradd -m -s /bin/bash -c 'La Roulotte Solidaire Toulouse Admin' {ADMIN_USER}")
        if code != 0:
            print("Erreur useradd:", err)
            return
        code, out, err = run_cmd(f"echo \"{ADMIN_USER}:{ADMIN_PASS}\" | chpasswd")
        if code != 0:
            print("Erreur chpasswd:", err)
            return
        run_cmd(f"usermod -aG sudo {ADMIN_USER}")
        print(f"Admin {ADMIN_USER} créé. Changez le mot de passe immédiatement.")
        log("CREATE_ADMIN", ADMIN_USER)

    async def action_show_logs(self):
        # show last 200 lines of log
        if not os.path.exists(LOGFILE):
            self.info.update_info("Aucun fichier de log trouvé.")
            return
        with open(LOGFILE, "r", encoding="utf-8", errors="ignore") as f:
            lines = f.readlines()[-200:]
        text = "".join(lines) or "Fichier de log vide."
        self.info.update_info(text)

    async def action_quit(self):
        log("EXIT", "UserManager TUI arrêté")
        await self.action_shutdown()

    async def action_refresh(self):
        self.users_table.refresh_table()
        self.info.update_info("Rafraîchi.")

if __name__ == "__main__":
    if os.geteuid() != 0:
        print("Ce script doit être exécuté en root (sudo).")
        sys.exit(1)
    setup_logging()
    app = UserManagerApp()
    app.run()
