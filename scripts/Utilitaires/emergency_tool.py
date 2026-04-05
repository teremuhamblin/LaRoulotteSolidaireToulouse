#!/usr/bin/env python3
# ==============================================================================
#  Emergency Tools – La Route
# ==============================================================================

import os
import shutil
import subprocess

CYAN = "\033[96m"
RED = "\033[91m"
GREEN = "\033[92m"
RESET = "\033[0m"

def banner():
    print(f"{CYAN}=== Emergency Tools – La Route ==={RESET}")

def check_ping():
    print("Test réseau (ping 8.8.8.8)...")
    r = subprocess.call(["ping", "-c", "2", "8.8.8.8"],
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL)
    if r == 0:
        print(f"{GREEN}OK : Internet accessible{RESET}")
    else:
        print(f"{RED}Échec : pas de connexion{RESET}")

def check_battery():
    if shutil.which("termux-battery-status"):
        out = subprocess.check_output(["termux-battery-status"]).decode()
        print(out)
    else:
        print("Batterie : non disponible sur ce système.")

def check_storage():
    st = shutil.disk_usage("/")
    print(f"Espace libre : {st.free // (1024**2)} Mo")

def main():
    banner()
    check_ping()
    check_battery()
    check_storage()

if __name__ == "__main__":
    main()
