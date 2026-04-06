#!/usr/bin/env bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : install_termux_godmode.sh
#  Version : 1.0.0-godmode
#  Objectif :
#     - Absolute God Mode installer pour Termux
#     - Profils, Modes, Plugins, Hooks, Auto-update, Integrity check
#     - JSON + text logging, dry-run, verbose, silent, parallel installs
# ==============================================================================

set -euo pipefail
IFS=$'\n\t'

# -------------------------
# Configuration globale
# -------------------------
APP_NAME="Termux GodMode - La Roulotte"
VERSION="1.0.0-godmode"
BASE_DIR="$HOME/.local/share/roulotte-termux"
MODULES_DIR="$BASE_DIR/modules"
PLUGINS_DIR="$BASE_DIR/plugins"
CONFIG_DIR="$HOME/.config/roulotte"
CONFIG_FILE="$CONFIG_DIR/config.yaml"
LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"
SCRIPT_PATH="${BASH_SOURCE[0]}"
SELF_UPDATE_URL="${SELF_UPDATE_URL:-}" # set to raw URL of script for auto-update
DEFAULT_PROFILE="standard"

# Defaults
DRY_RUN=false
VERBOSE=false
SILENT=false
PROFILE="$DEFAULT_PROFILE"
MODES_TO_INSTALL=()
INSTALL_MODULE=""
SELF_UPDATE=false

# Ensure directories
mkdir -p "$BASE_DIR" "$MODULES_DIR" "$PLUGINS_DIR" "$CONFIG_DIR" "$LOG_DIR"

# -------------------------
# Utilities: colors, spinner, json log
# -------------------------
C="\e[96m"; G="\e[92m"; Y="\e[93m"; R="\e[91m"; M="\e[95m"; B="\e[94m"; RESET="\e[0m"

timestamp() { date --iso-8601=seconds 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S%z"; }

log_text() {
  local level="$1"; shift
  local msg="$*"
  echo -e "[$(timestamp)] [$level] $msg" | tee -a "$LOG_FILE"
}

log_json() {
  local level="$1"; shift
  local msg="$*"
  # Minimal JSON line
  printf '{"time":"%s","level":"%s","msg":"%s"}\n' "$(timestamp)" "$level" "$(echo "$msg" | sed 's/"/\\"/g')" >> "$LOG_FILE"
}

log() {
  if [ "$SILENT" = true ]; then
    log_json "INFO" "$*"
    return
  fi
  if [ "$VERBOSE" = true ]; then
    log_text "INFO" "$*"
  else
    log_text "INFO" "$*"
  fi
  log_json "INFO" "$*"
}

warn() {
  log_text "WARN" "$*"
  log_json "WARN" "$*"
}

error() {
  log_text "ERROR" "$*"
  log_json "ERROR" "$*"
}

die() {
  error "$*"
  exit 1
}

spinner_start() {
  # spinner in background, returns PID in SPINNER_PID
  local msg="$1"
  printf "%s " "$msg"
  local i=0
  ( while :; do printf "\b${SPINNER_CHARS:i%${#SPINNER_CHARS}:1}"; i=$((i+1)); sleep 0.1; done ) &
  SPINNER_PID=$!
  disown
}

spinner_stop() {
  if [ -n "${SPINNER_PID:-}" ]; then
    kill "$SPINNER_PID" 2>/dev/null || true
    unset SPINNER_PID
    printf "\b"
    echo " done"
  fi
}

# -------------------------
# Argument parsing
# -------------------------
print_help() {
  cat <<EOF
$APP_NAME - $VERSION

Usage: $0 [options]

Options:
  --profile <standard|pro|roulotte|ultra|combo>   Select profile to install
  --modes <mode1,mode2,all>                      Install modes (terrain,devops,security,cloud,all)
  --install-module <module>                      Install a specific module by name
  --dry-run                                      Simulate actions without making changes
  --verbose                                      Verbose output
  --silent                                       Silent mode (logs only)
  --self-update                                  Update this script from configured URL
  --help                                         Show this help
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --profile) PROFILE="${2:-}"; shift 2;;
    --modes) IFS=',' read -r -a MODES_TO_INSTALL <<< "${2:-}"; shift 2;;
    --install-module) INSTALL_MODULE="${2:-}"; shift 2;;
    --dry-run) DRY_RUN=true; shift;;
    --verbose) VERBOSE=true; shift;;
    --silent) SILENT=true; shift;;
    --self-update) SELF_UPDATE=true; shift;;
    --help) print_help; exit 0;;
    *) warn "Option inconnue: $1"; shift;;
  esac
done

# -------------------------
# Environment checks
# -------------------------
ensure_termux() {
  if ! command -v pkg >/dev/null 2>&1; then
    die "Ce script doit être exécuté dans Termux (commande 'pkg' introuvable)."
  fi
}

ensure_internet() {
  if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    warn "Connexion Internet non détectée. Certaines étapes peuvent échouer."
  fi
}

# -------------------------
# Self-update
# -------------------------
self_update() {
  if [ -z "$SELF_UPDATE_URL" ]; then
    warn "SELF_UPDATE_URL non configuré. Auto-update impossible."
    return 1
  fi
  log "Vérification mise à jour depuis $SELF_UPDATE_URL"
  tmpf="$(mktemp)"
  if ! curl -fsSL "$SELF_UPDATE_URL" -o "$tmpf"; then
    warn "Impossible de télécharger la mise à jour."
    rm -f "$tmpf"
    return 1
  fi
  # Optional integrity check: compare SHA256 if provided in URL+".sha256"
  if [ -n "${SELF_UPDATE_CHECKSUM:-}" ]; then
    echo "${SELF_UPDATE_CHECKSUM}  $tmpf" | sha256sum -c - >/dev/null 2>&1 || {
      warn "Checksum mismatch pour la mise à jour."
      rm -f "$tmpf"
      return 1
    }
  fi
  # Replace script
  cp "$tmpf" "$SCRIPT_PATH"
  chmod +x "$SCRIPT_PATH"
  rm -f "$tmpf"
  log "Script mis à jour avec succès."
  return 0
}

# -------------------------
# Config loader (YAML minimal)
# -------------------------
load_config() {
  # Default config values
  DEFAULT_REPO_URL="${DEFAULT_REPO_URL:-}"
  DEFAULT_REMOTE_NAME="${DEFAULT_REMOTE_NAME:-roulotte-remote}"
  # If config file exists, parse simple key: value lines
  if [ -f "$CONFIG_FILE" ]; then
    while IFS= read -r line; do
      # skip comments and empty
      [[ "$line" =~ ^[[:space:]]*# ]] && continue
      [[ -z "$line" ]] && continue
      key=$(echo "$line" | sed -E 's/:[[:space:]]*.*$//')
      val=$(echo "$line" | sed -E 's/^[^:]+:[[:space:]]*//')
      key=$(echo "$key" | tr -d ' ')
      case "$key" in
        repo_url) DEFAULT_REPO_URL="$val" ;;
        remote_name) DEFAULT_REMOTE_NAME="$val" ;;
        *) ;;
      esac
    done < "$CONFIG_FILE"
  fi
}

# -------------------------
# Hook system (pre/post)
# -------------------------
run_hook() {
  local hook_name="$1"
  shift
  local hook_file="$BASE_DIR/hooks/${hook_name}.sh"
  if [ -x "$hook_file" ]; then
    log "Exécution hook: $hook_name"
    if [ "$DRY_RUN" = true ]; then
      log "[dry-run] would run $hook_file $*"
    else
      "$hook_file" "$@"
    fi
  fi
}

# -------------------------
# Plugin loader
# -------------------------
load_plugins() {
  if [ -d "$PLUGINS_DIR" ]; then
    for p in "$PLUGINS_DIR"/*.sh; do
      [ -f "$p" ] || continue
      # shellcheck source=/dev/null
      source "$p" || warn "Impossible de charger plugin $p"
      log "Plugin chargé: $(basename "$p")"
    done
  fi
}

# -------------------------
# Module installer helpers
# -------------------------
run_pkg() {
  local cmd="$*"
  if [ "$DRY_RUN" = true ]; then
    log "[dry-run] pkg: $cmd"
    return 0
  fi
  if [ "$VERBOSE" = true ]; then
    pkg $cmd 2>&1 | tee -a "$LOG_FILE"
  else
    pkg $cmd >>"$LOG_FILE" 2>&1
  fi
}

run_cargo_install() {
  local crate="$1"
  if [ "$DRY_RUN" = true ]; then
    log "[dry-run] cargo install $crate"
    return 0
  fi
  if command -v cargo >/dev/null 2>&1; then
    cargo install --locked "$crate" >>"$LOG_FILE" 2>&1 || warn "cargo install $crate failed"
  else
    warn "cargo absent, impossible d'installer $crate via cargo"
  fi
}

run_curl_sh() {
  local url="$1"
  if [ "$DRY_RUN" = true ]; then
    log "[dry-run] curl | sh -> $url"
    return 0
  fi
  curl -fsSL "$url" | sh -s -- -y >>"$LOG_FILE" 2>&1 || warn "curl | sh failed for $url"
}

# -------------------------
# Core modules
# -------------------------
module_core() {
  log "Module core: installation paquets essentiels"
  run_pkg "update -y"
  run_pkg "upgrade -y"
  run_pkg "install -y git curl wget zsh python ruby nodejs openssh neovim tmux htop fzf ripgrep fd bat proot-distro termux-api clang make rust cargo fastfetch"
  # termux storage
  if [ "$DRY_RUN" = false ]; then
    termux-setup-storage || warn "termux-setup-storage failed or requires user interaction"
  fi
}

module_modern_tools() {
  log "Module modern-tools: eza, starship, yazi, zellij"
  run_pkg "install -y eza"
  run_pkg "install -y ripgrep fd"
  run_cargo_install "yazi-fm" || true
  run_cargo_install "yazi-cli" || true
  run_cargo_install "zellij" || true
  run_curl_sh "https://starship.rs/install.sh"
}

module_shell() {
  log "Module shell: zsh + starship configuration"
  if [ "$DRY_RUN" = false ]; then
    chsh -s zsh || warn "chsh may fail on some Termux setups"
  fi
  mkdir -p "$HOME/.config"
  cat > "$HOME/.zshrc" <<'EOF'
# Roulotte Zsh config
export PATH=$PATH:$HOME/.cargo/bin
eval "$(starship init zsh)"
export FZF_DEFAULT_COMMAND='fd --type f'
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons'
alias la='eza -lha --icons'
alias cat='bat'
alias grep='rg'
EOF
  cat > "$HOME/.config/starship.toml" <<'EOF'
add_newline = true
[character]
success_symbol = "➜"
error_symbol = "✗"
[directory]
style = "cyan"
truncation_length = 3
EOF
}

# -------------------------
# Profile modules
# -------------------------
module_profile_pro() {
  log "Profile PRO: outils Dev/Ops"
  run_pkg "install -y btop bottom lazygit zoxide jq"
  log "Installation proot-distro Ubuntu (peut prendre du temps)"
  if [ "$DRY_RUN" = false ]; then
    proot-distro install ubuntu >>"$LOG_FILE" 2>&1 || warn "proot-distro ubuntu failed"
  fi
  mkdir -p "$HOME/.config/zellij"
  cat > "$HOME/.config/zellij/config.kdl" <<'EOF'
pane_frames true
theme "default"
EOF
}

module_profile_roulotte() {
  log "Profile ROULOTTE: workspace, scripts, sync"
  WORKDIR="$HOME/roulotte"
  mkdir -p "$WORKDIR"/{scripts,logs,data,config}
  cat >> "$HOME/.zshrc" <<'EOF'

# Profil Roulotte
export ROULOTTE_HOME="$HOME/roulotte"
alias rcd='cd "$ROULOTTE_HOME"'
alias rlogs='cd "$ROULOTTE_HOME/logs"'
alias rscripts='cd "$ROULOTTE_HOME/scripts"'
EOF
  cat > "$WORKDIR/scripts/sync_git.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="$HOME/roulotte"
LOG_FILE="$REPO_DIR/logs/sync_git_$(date +%Y%m%d_%H%M%S).log"
echo "[INFO] Sync Git Roulotte - $(date)" | tee -a "$LOG_FILE"
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "[WARN] Aucun dépôt Git dans $REPO_DIR" | tee -a "$LOG_FILE"
  exit 0
fi
cd "$REPO_DIR"
git pull --rebase | tee -a "$LOG_FILE"
git status | tee -a "$LOG_FILE"
EOF
  chmod +x "$WORKDIR/scripts/sync_git.sh"
}

module_profile_ultra() {
  log "Profile ULTRA: dashboard, themes, fastfetch, yazi config"
  mkdir -p "$HOME/.config/fastfetch" "$HOME/.config/yazi" "$HOME/.config/zellij/layouts"
  cat > "$HOME/.config/fastfetch/config.jsonc" <<'EOF'
{
  "logo": { "type": "auto" },
  "display": { "separator": "  " }
}
EOF
  cat > "$HOME/.config/yazi/yazi.toml" <<'EOF'
[manager]
show_hidden = true
sort_by = "name"
EOF
  cat > "$HOME/.config/zellij/layouts/dashboard.kdl" <<'EOF'
layout {
  pane size=1 borderless=true {
    plugin location="zellij:tab-bar"
  }
  pane split_direction="vertical" {
    pane { command "fastfetch" }
    pane { command "htop" }
  }
}
EOF
  cat >> "$HOME/.zshrc" <<'EOF'
alias dashboard='zellij --layout dashboard'
EOF
}

# -------------------------
# Modes modules
# -------------------------
module_mode_terrain() {
  log "Mode TERRAIN: termux-location, camera, sensor helpers"
  run_pkg "install -y termux-api"
  mkdir -p "$HOME/roulotte/terrain"/{photos,logs,forms}
  cat > "$HOME/roulotte/terrain/capture_position.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
OUT_DIR="$HOME/roulotte/terrain/logs"
mkdir -p "$OUT_DIR"
FILE="$OUT_DIR/gps_$(date +%Y%m%d_%H%M%S).json"
termux-location --request once > "$FILE"
echo "Position enregistrée dans $FILE"
EOF
  chmod +x "$HOME/roulotte/terrain/capture_position.sh"
  cat > "$HOME/roulotte/terrain/capture_photo.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
OUT_DIR="$HOME/roulotte/terrain/photos"
mkdir -p "$OUT_DIR"
FILE="$OUT_DIR/photo_$(date +%Y%m%d_%H%M%S).jpg"
termux-camera-photo "$FILE"
echo "Photo enregistrée dans $FILE"
EOF
  chmod +x "$HOME/roulotte/terrain/capture_photo.sh"
  cat >> "$HOME/.zshrc" <<'EOF'

# Mode terrain
alias rterrain='cd "$HOME/roulotte/terrain"'
EOF
}

module_mode_devops() {
  log "Mode DEVOPS: kubectl, helm, helpers"
  run_pkg "install -y kubectl"
  # Helm installer
  if [ "$DRY_RUN" = false ]; then
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash >>"$LOG_FILE" 2>&1 || warn "helm install failed"
  fi
  mkdir -p "$HOME/roulotte/devops"
  cat > "$HOME/roulotte/devops/kube_contexts.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "Contexts Kubernetes disponibles :"
kubectl config get-contexts
EOF
  chmod +x "$HOME/roulotte/devops/kube_contexts.sh"
  cat >> "$HOME/.zshrc" <<'EOF'

# DevOps
alias rdevops='cd "$HOME/roulotte/devops"'
EOF
}

module_mode_security() {
  log "Mode SÉCURITÉ: openssl, gnupg, age, audit scripts"
  run_pkg "install -y openssl gnupg age"
  mkdir -p "$HOME/roulotte/security"
  cat > "$HOME/roulotte/security/audit_basic.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "=== Audit basique Termux ==="
echo "- Utilisateur : $(whoami)"
echo "- Shell : $SHELL"
echo "- Clés SSH :"
ls -l ~/.ssh || echo "Pas de ~/.ssh"
EOF
  chmod +x "$HOME/roulotte/security/audit_basic.sh"
  cat >> "$HOME/.zshrc" <<'EOF'

# Sécurité
alias rsec='cd "$HOME/roulotte/security"'
EOF
}

module_mode_cloud() {
  log "Mode SYNC CLOUD: rclone + sync helpers"
  run_pkg "install -y rclone"
  mkdir -p "$HOME/roulotte/cloud"
  cat > "$HOME/roulotte/cloud/sync_roulotte.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
REMOTE_NAME="${REMOTE_NAME:-roulotte-remote}"
LOCAL_DIR="$HOME/roulotte"
REMOTE_DIR="${REMOTE_DIR:-roulotte-backup}"
rclone sync "$LOCAL_DIR" "${REMOTE_NAME}:${REMOTE_DIR}" --progress --verbose
EOF
  chmod +x "$HOME/roulotte/cloud/sync_roulotte.sh"
  cat >> "$HOME/.zshrc" <<'EOF'

# Sync cloud
alias rcloud='cd "$HOME/roulotte/cloud"'
EOF
}

# -------------------------
# High-level installers
# -------------------------
install_profile() {
  local p="$1"
  case "$p" in
    standard)
      log "Installation profile: standard"
      module_core
      module_modern_tools
      module_shell
      ;;
    pro)
      log "Installation profile: pro"
      module_core
      module_modern_tools
      module_shell
      module_profile_pro
      ;;
    roulotte)
      log "Installation profile: roulotte"
      module_core
      module_modern_tools
      module_shell
      module_profile_roulotte
      ;;
    ultra)
      log "Installation profile: ultra"
      module_core
      module_modern_tools
      module_shell
      module_profile_ultra
      ;;
    combo)
      log "Installation profile: combo (tout)"
      module_core
      module_modern_tools
      module_shell
      module_profile_pro
      module_profile_roulotte
      module_profile_ultra
      ;;
    *)
      warn "Profile inconnu: $p"
      ;;
  esac
}

install_modes() {
  local modes=("$@")
  for m in "${modes[@]}"; do
    case "$m" in
      terrain) module_mode_terrain ;;
      devops) module_mode_devops ;;
      security) module_mode_security ;;
      cloud) module_mode_cloud ;;
      all)
        module_mode_terrain
        module_mode_devops
        module_mode_security
        module_mode_cloud
        ;;
      *) warn "Mode inconnu: $m" ;;
    esac
  done
}

# -------------------------
# Integrity check helper
# -------------------------
verify_file_sha256() {
  local file="$1"; local expected="$2"
  if command -v sha256sum >/dev/null 2>&1; then
    echo "${expected}  ${file}" | sha256sum -c - >/dev/null 2>&1
  else
    warn "sha256sum absent, skip integrity check"
    return 1
  fi
}

# -------------------------
# Parallel installer helper
# -------------------------
parallel_run() {
  # Accepts commands as arguments; runs them in background and waits
  local cmds=("$@")
  local pids=()
  for cmd in "${cmds[@]}"; do
    if [ "$DRY_RUN" = true ]; then
      log "[dry-run] would run: $cmd"
    else
      bash -c "$cmd" >>"$LOG_FILE" 2>&1 &
      pids+=($!)
    fi
  done
  for pid in "${pids[@]}"; do
    wait "$pid" || warn "Process $pid failed"
  done
}

# -------------------------
# Finalization & summary
# -------------------------
finalize() {
  log "Finalisation: nettoyage et résumé"
  # Source zshrc to apply aliases (only if not dry-run)
  if [ "$DRY_RUN" = false ]; then
    log "Installation terminée. Redémarrer Termux ou exécuter: source ~/.zshrc"
  else
    log "[dry-run] Simulation terminée."
  fi
  log "Log complet : $LOG_FILE"
}

# -------------------------
# Main flow
# -------------------------
main() {
  ensure_termux
  load_config
  load_plugins

  if [ "$SELF_UPDATE" = true ]; then
    self_update || warn "Self-update échouée"
  fi

  run_hook "pre_install" "$PROFILE"

  if [ -n "$INSTALL_MODULE" ]; then
    log "Installation module demandé: $INSTALL_MODULE"
    case "$INSTALL_MODULE" in
      core) module_core ;;
      modern-tools) module_modern_tools ;;
      shell) module_shell ;;
      pro) module_profile_pro ;;
      roulotte) module_profile_roulotte ;;
      ultra) module_profile_ultra ;;
      terrain) module_mode_terrain ;;
      devops) module_mode_devops ;;
      security) module_mode_security ;;
      cloud) module_mode_cloud ;;
      *) warn "Module inconnu: $INSTALL_MODULE" ;;
    esac
  else
    log "Début installation profile: $PROFILE"
    install_profile "$PROFILE"
    if [ "${#MODES_TO_INSTALL[@]}" -gt 0 ]; then
      install_modes "${MODES_TO_INSTALL[@]}"
    fi
  fi

  run_hook "post_install" "$PROFILE"

  finalize
}

# Trap for cleanup
trap 'error "Interrompu"; exit 1' INT TERM

# Run main
main "$@"

# End of script
