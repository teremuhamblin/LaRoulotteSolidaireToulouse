#!/usr/bin/env python3
# ==============================================================================
#  La Roulotte Solidaire Toulouse - Rapport de maintenance avancé
#  Fichier : maintenance_report.py
#  Version : 3.0
# ==============================================================================

import json
import sys
from pathlib import Path
from datetime import datetime

ICONS = {
    "success": "🟢",
    "warning": "🟡",
    "error":   "🔴",
    "unknown": "⚪",
}

def load_json(path: Path) -> dict:
    if not path.exists():
        raise FileNotFoundError(f"Fichier introuvable : {path}")
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)

def header_text(data: dict) -> str:
    ts_raw = data.get("timestamp", "")
    try:
        ts = datetime.fromisoformat(ts_raw).strftime("%d/%m/%Y %H:%M:%S")
    except Exception:
        ts = ts_raw or "inconnu"

    dry = data.get("dry_run", False)
    dry_str = "OUI (simulation)" if dry else "NON"

    lines = [
        "==============================================================",
        f"  Rapport de maintenance — {data.get('project', 'Projet inconnu')}",
        "==============================================================",
        f"  Date : {ts}",
        f"  Hôte : {data.get('host', 'hôte inconnu')}",
        f"  Mode dry-run : {dry_str}",
        "==============================================================",
        "",
    ]
    return "\n".join(lines)

def format_task_text(task: dict, index: int) -> str:
    name = task.get("name", f"Tâche {index}")
    status = task.get("status", "unknown")
    details = task.get("details", "").strip()
    icon = ICONS.get(status, ICONS["unknown"])

    lines = [f"[{index}] {icon}  {name} ({status})"]
    if details:
        lines.append("    Détails :")
        for line in details.splitlines():
            lines.append(f"      - {line}")
    lines.append("")
    return "\n".join(lines)

def generate_text_report(data: dict) -> str:
    out = [header_text(data)]
    tasks = data.get("tasks", [])
    if not tasks:
        out.append("Aucune tâche enregistrée.\n")
    else:
        out.append(f"Nombre de tâches : {len(tasks)}\n")
        for i, t in enumerate(tasks, start=1):
            out.append(format_task_text(t, i))
    return "\n".join(out)

def generate_markdown_report(data: dict, path: Path) -> None:
    ts = data.get("timestamp", "")
    dry = data.get("dry_run", False)
    dry_str = "Oui (simulation)" if dry else "Non"

    with path.open("w", encoding="utf-8") as f:
        f.write(f"# Rapport de maintenance — {data.get('project', 'Projet inconnu')}\n\n")
        f.write(f"- **Date :** `{ts}`\n")
        f.write(f"- **Hôte :** `{data.get('host', 'hôte inconnu')}`\n")
        f.write(f"- **Mode dry-run :** `{dry_str}`\n\n")

        tasks = data.get("tasks", [])
        if not tasks:
            f.write("Aucune tâche enregistrée.\n")
            return

        f.write("## Tâches\n\n")
        for t in tasks:
            name = t.get("name", "Tâche")
            status = t.get("status", "unknown")
            details = t.get("details", "").strip()
            icon = ICONS.get(status, ICONS["unknown"])

            f.write(f"### {icon} {name}\n")
            f.write(f"- **Statut :** `{status}`\n")
            if details:
                f.write("- **Détails :**\n")
                for line in details.splitlines():
                    f.write(f"  - {line}\n")
            f.write("\n")

def main(argv=None):
    argv = argv or sys.argv[1:]
    if not argv:
        print("Usage : maintenance_report.py <rapport.json>", file=sys.stderr)
        sys.exit(1)

    report_path = Path(argv[0])

    try:
        data = load_json(report_path)
    except Exception as e:
        print(f"Erreur : {e}", file=sys.stderr)
        sys.exit(1)

    # Rapport texte
    txt_report = generate_text_report(data)
    txt_path = report_path.with_suffix(".txt")
    txt_path.write_text(txt_report, encoding="utf-8")
    print(f"Rapport TXT généré : {txt_path}")

    # Rapport Markdown
    md_path = report_path.with_suffix(".md")
    generate_markdown_report(data, md_path)
    print(f"Rapport Markdown généré : {md_path}")

if __name__ == "__main__":
    main()
