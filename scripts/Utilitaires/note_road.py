#!/usr/bin/env python3
# ==============================================================================
#  Notes Road – La Roulotte Solidaire Toulouse
# ==============================================================================

from datetime import datetime
from pathlib import Path

YELLOW = "\033[93m"
GREEN = "\033[92m"
RESET = "\033[0m"

NOTES_FILE = Path("notes_route.txt")

def banner():
    print(f"{YELLOW}=== Notes de route – La Roulotte ==={RESET}")

def main():
    banner()
    note = input("Note : ").strip()
    if not note:
        print("Aucune note enregistrée.")
        return

    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    entry = f"[{ts}] {note}\n"

    with NOTES_FILE.open("a", encoding="utf-8") as f:
        f.write(entry)

    print(f"{GREEN}Note enregistrée dans {NOTES_FILE}{RESET}")

if __name__ == "__main__":
    main()
