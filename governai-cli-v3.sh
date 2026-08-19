#!/usr/bin/env bash
# GovernAI CLI - Antigravity edition
# Run as Administrator (Git Bash / WSL on Windows)
# Usage: bash agy-cli.sh [slash-command] [args]
# Close app with: agy cli  (or type /agy or /quit)
set -u

APP_NAME="GovernAI CLI"
CODENAME="Antigravity"
VERSION="1.0.0"
STATE_DIR="${GOVERN_AI_HOME:-$HOME/.governai-cli}"
DB_FILE="$STATE_DIR/state.env"
REPORT_DIR="$STATE_DIR/reports"
AUDIT_LOG="$STATE_DIR/audit.log"
CHAT_LOG="$STATE_DIR/chat.log"
INSTALL_LOG="$STATE_DIR/install.log"
mkdir -p "$REPORT_DIR"

ESC="$(printf '\033')"
RESET="${ESC}[0m"; BOLD="${ESC}[1m"; DIM="${ESC}[2m"
CYAN="${ESC}[36m"; GREEN="${ESC}[32m"; YELLOW="${ESC}[33m"; RED="${ESC}[31m"
BLUE="${ESC}[34m"; MAGENTA="${ESC}[35m"; WHITE="${ESC}[97m"; BG_CYAN="${ESC}[46m"

LOGO_LINES=(
"                      .__"
"_____  _______________|  | _____ \\_ |__   ______"
"\\__  \\ \\___   /\\_  __ \\  | \\__  \\ | __ \\ /  ___/"
" / __ \\_/    /  |  | \\/  |__/ __ \\| \\_\\ \\___ \\"
"(____  /_____ \\ |__|  |____(____  /___  /____  >"
"     \\/      \\/                 \\/    \\/     \\/"
)
SUBTITLE="   A N T I G R A V I T Y   C L I   ::   AI Governance Suite"

now() { date '+%Y-%m-%dT%H:%M:%S%z'; }
audit() { printf '%s | %s\n' "$(now)" "$*" >> "$AUDIT_LOG"; }
chatlog() { printf '%s | %s\n' "$(now)" "$*" >> "$CHAT_LOG"; }

load_state() {
  PROFILE=""; PERMISSION=""; CONSENT=""; ORG=""; ASSESSMENT=""; OWNER=""
  FRAMEWORKS=""; SELECTED_ITEMS=""; SYSTEMS="0"; FINDINGS="0"
  TOOLS_DETECTED=""; TOOLS_SELECTED=""; COMPLIANCE=""; LAST_REPORT=""; LAST_CODESCAN=""
  [ -f "$DB_FILE" ] && . "$DB_FILE"
}

save_state() {
  umask 077
  cat > "$DB_FILE" <<EOF
PROFILE=$(printf '%q' "${PROFILE:-}")
PERMISSION=$(printf '%q' "${PERMISSION:-}")
CONSENT=$(printf '%q' "${CONSENT:-}")
ORG=$(printf '%q' "${ORG:-}")
ASSESSMENT=$(printf '%q' "${ASSESSMENT:-}")
OWNER=$(printf '%q' "${OWNER:-}")
FRAMEWORKS=$(printf '%q' "${FRAMEWORKS:-}")
SELECTED_ITEMS=$(printf '%q' "${SELECTED_ITEMS:-}")
SYSTEMS=$(printf '%q' "${SYSTEMS:-0}")
FINDINGS=$(printf '%q' "${FINDINGS:-0}")
TOOLS_DETECTED=$(printf '%q' "${TOOLS_DETECTED:-}")
TOOLS_SELECTED=$(printf '%q' "${TOOLS_SELECTED:-}")
COMPLIANCE=$(printf '%q' "${COMPLIANCE:-}")
LAST_REPORT=$(printf '%q' "${LAST_REPORT:-}")
LAST_CODESCAN=$(printf '%q' "${LAST_CODESCAN:-}")
EOF
}

pause() { read -r -p $'\nPress Enter to continue...' _ || true; }

clear_screen() { printf '%b' "${ESC}[2J${ESC}[H"; }

# ---------- Logo animation ----------
animate_logo() {
  clear_screen
  local i j line
  # Frame 1: fade-in char by char
  for i in "${!LOGO_LINES[@]}"; do
    line="${LOGO_LINES[$i]}"
    local n=${#line}
    for ((j=0; j<=n; j++)); do
      printf '\r'
      printf '%b' "${CYAN}${BOLD}"
      printf '%s' "${line:0:j}"
      printf '%b' "${RESET}"
      sleep 0.003
    done
    printf '\n'
  done
  # Glow pulse
  local c
  for c in 90 95 96 97 96 95 90; do
    printf '%b' "${ESC}[2A"
    for i in "${!LOGO_LINES[@]}"; do
      printf '%b%b%s%b\n' "${ESC}[38;5;${c}m" "$BOLD" "${LOGO_LINES[$i]}" "$RESET"
    done
    sleep 0.05
  done
  printf '\n%b%s%b\n\n' "${MAGENTA}${BOLD}" "$SUBTITLE" "$RESET"
}

# ---------- Spinner ----------
spinner() {
  local label="$1"; local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'; local i
  for i in {1..18}; do printf '\r%b%s %s%b' "$CYAN" "$label" "${frames:i%10:1}" "$RESET"; sleep 0.05; done
  printf '\r%b%s done%b\n' "${GREEN}" "$label" "$RESET"
}

# ---------- Administrator check ----------
admin_note() {
  case "${OSTYPE:-}" in
    msys*|cygwin*|win32*)
      printf '%b\n' "${YELLOW}[!] For system-wide install, run Git Bash as Administrator.${RESET}"
      ;;
  esac
}

is_admin() {
  command -v net.exe >/dev/null 2>&1 && net session >/dev/null 2>&1 && return 0
  return 1
}

# ---------- Program scanner ----------
scan_programs() {
  TOOLS_DETECTED=""
  local found=()
  local cmds=(claude chatgpt gpt copilot cursor windsurf code codium ollama n8n node npm python python3 git docker wsl powershell pwsh gh azure aws gcloud kubectl tf terraform ansible vault playwright selenium postman insomnia jq yq ripgrep fd rg fzf zoxide starship go rustc cargo java mvn gradle dotnet rg)
  local pretty=(Claude CLI ChatGPT GitHubCopilot Cursor Windsurf VSCode VSCodium Ollama n8n NodeJS NPM Python Python3 Git Docker WSL PowerShell pwsh GitHubCLI AzureCLI AWSCLI gcloud kubectl Terraform Terraform Ansible Vault Playwright Selenium Postman Insomnia jq yq ripgrep fd ripgrep fzf zoxide Starship Go Rust Cargo Java Maven Gradle dotnet ripgrep ripgrep)
  local i
  for i in "${!cmds[@]}"; do
    if command -v "${cmds[$i]}" >/dev/null 2>&1; then
      found+=("${pretty[$i]}")
    fi
  done
  # Check Program Files
  local pf="/c/Program Files" pf86="/c/Program Files (x86)" lu="$LOCALAPPDATA" au="$APPDATA"
  [ -d "$pf/Claude" ] && found+=(Claude-Desktop)
  [ -d "$pf/Microsoft VS Code" ] && found+=(VSCode-Install)
  [ -d "$pf/Cursor" ] && found+=(Cursor-Install)
  [ -d "$pf/Windsurf" ] && found+=(Windsurf-Install)
  [ -d "$pf/n8n" ] && found+=(n8n-Desktop)
  [ -d "$pf/Ollama" ] && found+=(Ollama-Install)
  [ -d "$pf/Postman" ] && found+=(Postman-Install)
  [ -d "$pf/GitHub CLI" ] && found+=(GitHubCLI-Install)
  [ -d "$pf/Docker" ] && found+=(Docker-Install)
  [ -d "$pf/PowerShell" ] && found+=(PowerShell-7)
  [ -d "$pf/Google/Chrome" ] && found+=(Chrome)
  [ -d "$pf/Microsoft/Edge" ] && found+=(Edge)
  [ -d "$pf/Mozilla Firefox" ] && found+=(Firefox)
  [ -d "$pf/7-Zip" ] && found+=(7-Zip)
  [ -d "$pf/Microsoft/EdgeWebView" ] && found+=(EdgeWebView)
  # Check extensions dirs (mock)
  [ -d "$au/Code/User/extensions" ] && found+=(VSCode-Extensions)
  [ -d "$au/Cursor/User/extensions" ] && found+=(Cursor-Extensions)
  # Dedupe
  local unique
  unique=$(printf '%s\n' "${found[@]}" | awk '!seen[$0]++')
  TOOLS_DETECTED=$(echo "$unique" | tr '\n' ',' | sed 's/,$//')
  audit "scan_programs detected=$TOOLS_DETECTED"
}

# ---------- Arrow-key MCQ navigation ----------
# Args: prompt ; option1 option2 ... ; sets global SELECTED_INDEX (0-based)
nav_select() {
  local prompt="$1"; shift
  local options=("$@")
  local n=${#options[@]}
  local idx=0
  local key key2
  # hide cursor
  printf '%b' "${ESC}[?25l"
  while true; do
    printf '\r%b%s%b\n' "${BOLD}${CYAN}" "$prompt" "$RESET"
    local i
    for i in "${!options[@]}"; do
      if [ "$i" -eq "$idx" ]; then
        printf '  %b▶ %s%b\n' "${BG_CYAN}${BOLD}" "${options[$i]}" "$RESET"
      else
        printf '    %b%s%b\n' "$DIM" "${options[$i]}" "$RESET"
      fi
    done
    read -rsn1 key
    case "$key" in
      $'\x1b')
        read -rsn1 -t 0.1 key2 || true
        case "$key2" in
          '[') read -rsn1 -t 0.1 key2 || true
            case "$key2" in
              A) idx=$(( (idx - 1 + n) % n ));;
              B) idx=$(( (idx + 1) % n ));;
            esac;;
        esac;;
      ' '|'') SELECTED_INDEX=$idx; printf '%b' "${ESC}[?25h"; return 0;;
      q|Q) SELECTED_INDEX=-1; printf '%b' "${ESC}[?25h"; return 0;;
    esac
    # move cursor up to redraw
    printf '%b' "${ESC}[$((n+1))A"
  done
}

multi_select() {
  local prompt="$1"; shift
  local options=("$@")
  local n=${#options[@]}
  local idx=0
  local selected=()
  local i
  for ((i=0;i<n;i++)); do selected[i]=0; done
  local key key2
  printf '%b' "${ESC}[?25l"
  while true; do
    printf '\r%b%s%b  %b(Space=toggle, Enter=confirm, q=cancel)%b\n' "${BOLD}${CYAN}" "$prompt" "$RESET" "$DIM" "$RESET"
    for i in "${!options[@]}"; do
      local mark=" "
      [ "${selected[$i]}" = "1" ] && mark="x"
      if [ "$i" -eq "$idx" ]; then
        printf '  %b[%s] ▶ %s%b\n' "${BG_CYAN}${BOLD}" "$mark" "${options[$i]}" "$RESET"
      else
        printf '     [%s]  %s\n' "$mark" "${options[$i]}"
      fi
    done
    read -rsn1 key
    case "$key" in
      $'\x1b')
        read -rsn1 -t 0.1 key2 || true
        case "$key2" in
          '[') read -rsn1 -t 0.1 key2 || true
            case "$key2" in
              A) idx=$(( (idx-1+n) % n ));;
              B) idx=$(( (idx+1) % n ));;
            esac;;
        esac;;
      ' ') selected[$idx]=$(( 1-selected[idx] ));;
      '') MULTI_SELECTED=""; for ((i=0;i<n;i++)); do [ "${selected[$i]}" = "1" ] && MULTI_SELECTED="${MULTI_SELECTED}${MULTI_SELECTED:+,}${options[$i]}"; done
          printf '%b' "${ESC}[?25h"; return 0;;
      q|Q) MULTI_SELECTED=""; printf '%b' "${ESC}[?25h"; return 1;;
    esac
    printf '%b' "${ESC}[$((n+1))A"
  done
}

# ---------- Onboarding ----------
onboarding() {
  animate_logo
  spinner 'Initializing Antigravity runtime'
  spinner 'Mounting local state volumes'
  spinner 'Loading governance frameworks'
  admin_note
  printf '\n%bWelcome to %s.%b\n' "${GREEN}${BOLD}" "$APP_NAME" "$RESET"
  printf '%s\n' "This onboarding will scan your system for installed AI tools, code editors, live agents and extensions."
  pause

  scan_programs
  printf '\n%bDetected AI tools / editors / agents / extensions:%b\n' "${CYAN}${BOLD}" "$RESET"
  if [ -z "$TOOLS_DETECTED" ]; then
    printf '  %b(none detected)%b\n' "$DIM" "$RESET"
  else
    local i=1
    IFS=',' read -ra arr <<< "$TOOLS_DETECTED"
    for t in "${arr[@]}"; do printf '  %d. %s\n' "$i" "$t"; i=$((i+1)); done
  fi

  printf '\n%b[1/5] Permission Mode%b\n' "${CYAN}${BOLD}" "$RESET"
  nav_select 'Choose your operating permission mode:' 'Beginner' 'SMB' 'Enterprise' 'Custom scope'
  PROFILE=$SELECTED_INDEX
  case "$PROFILE" in 0) PROFILE="Beginner";; 1) PROFILE="SMB";; 2) PROFILE="Enterprise";; 3) PROFILE="Custom";; esac

  printf '\n%b[2/5] Tools selection (space to toggle, enter to confirm)%b\n' "${CYAN}${BOLD}" "$RESET"
  local opts
  if [ -z "$TOOLS_DETECTED" ]; then
    opts=("ChatGPT" "Microsoft Copilot" "Claude" "Gemini" "GitHub Copilot" "Cursor" "Windsurf" "Ollama" "n8n" "Power Automate" "Custom agent" "None")
  else
    IFS=',' read -ra arr <<< "$TOOLS_DETECTED"
    opts=("${arr[@]}" "None")
  fi
  multi_select "Select AI systems in scope:" "${opts[@]}"
  TOOLS_SELECTED="$MULTI_SELECTED"

  printf '\n%b[3/5] Compliance & Audit checklist severity%b\n' "${CYAN}${BOLD}" "$RESET"
  nav_select 'Choose audit severeness:' 'Critical-only' 'High+' 'Medium+' 'Low+' 'Full audit'
  COMPLIANCE=$SELECTED_INDEX
  case "$COMPLIANCE" in 0) COMPLIANCE="Critical";; 1) COMPLIANCE="High+";; 2) COMPLIANCE="Medium+";; 3) COMPLIANCE="Low+";; 4) COMPLIANCE="Full";; esac

  printf '\n%b[4/5] Frameworks (multi-select)%b\n' "${CYAN}${BOLD}" "$RESET"
  multi_select "Select applicable frameworks:" "NIST AI RMF" "ISO 42001" "ISO 27001" "EU AI Act" "NYC LL 144" "Colorado AI Act" "HIPAA" "GLBA" "ECOA/FCRA" "FERPA" "NAIC" "SOX" "COBIT" "DCAM" "OECD" "UNESCO" "EIF" "Agent Runtime Gov" "None / later"
  FRAMEWORKS="$MULTI_SELECTED"

  printf '\n%b[5/5] Organization details%b\n' "${CYAN}${BOLD}" "$RESET"
  read -r -p "Organization name: " ORG || ORG=""
  read -r -p "Assessment name [Assessment-$(date +%Y%m%d-%H%M%S)]: " ASSESSMENT || ASSESSMENT=""
  ASSESSMENT="${ASSESSMENT:-Assessment-$(date +%Y%m%d-%H%M%S)}"
  read -r -p "Accountable owner: " OWNER || OWNER=""

  printf '\n%bConsent & Scope%b\n' "${CYAN}${BOLD}" "$RESET"
  nav_select 'Consent to audit / set permission?' 'Yes - consent & audit' 'Yes - read-only' 'Review scope' 'No - exit'
  case "$SELECTED_INDEX" in
    0) CONSENT="audit";;
    1) CONSENT="readonly";;
    2) scope_form; nav_select 'Consent now?' 'Yes - audit' 'Yes - read-only' 'No - exit'
       case "$SELECTED_INDEX" in 0) CONSENT="audit";; 1) CONSENT="readonly";; 2) printf 'No data collected.\n'; exit 0;; esac;;
    3) CONSENT="no"; printf 'No data collected.\n'; exit 0;;
  esac

  save_state
  audit "onboarding completed profile=$PROFILE compliance=$COMPLIANCE consent=$CONSENT tools=$TOOLS_SELECTED frameworks=$FRAMEWORKS"
  printf '\n%b[SUCCESS] Onboarding complete. Opening Antigravity workspace...%b\n' "${GREEN}" "$RESET"
  sleep 1
}

scope_form() {
  printf '\n%bScope selection%b\n' "${CYAN}" "$RESET"
  SELECTED_ITEMS=""
  while true; do
    read -r -p 'Add file/folder with @, or /done: ' item || return 0
    [ "$item" = "/done" ] && break
    case "$item" in
      @*)
        item="${item#@}"
        if [ -e "$item" ]; then
          SELECTED_ITEMS="${SELECTED_ITEMS}${SELECTED_ITEMS:+|}$item"
          printf '%bAdded: %s%b\n' "${GREEN}" "$item" "$RESET"
        else
          SELECTED_ITEMS="${SELECTED_ITEMS}${SELECTED_ITEMS:+|}$item"
          printf '%bRetained as planned evidence reference: %s%b\n' "${YELLOW}" "$item" "$RESET"
        fi;;
      *) printf '%bUse @ before path. e.g. @C:/Projects/AI%b\n' "${YELLOW}" "$RESET";;
    esac
  done
  audit "scope=${SELECTED_ITEMS:-empty}"
}

# ---------- Forms ----------
intake_form() {
  [ -n "${CONSENT:-}" ] || onboarding
  printf '\n%bAI Intake%b\n' "${CYAN}${BOLD}" "$RESET"
  read -r -p "AI system name: " SYS_NAME || return 0
  read -r -p "Business purpose: " PURPOSE || PURPOSE=""
  nav_select 'Affects decisions about people?' 'No' 'Unknown' 'Yes'
  DECISION=$SELECTED_INDEX
  nav_select 'Processes personal / regulated data?' 'No' 'Unknown' 'Yes'
  DATA=$SELECTED_INDEX
  nav_select 'Operates autonomously?' 'No' 'Partially' 'Yes'
  AUTO=$SELECTED_INDEX
  nav_select 'Human review defined?' 'No' 'Partially' 'Yes'
  HUMAN=$SELECTED_INDEX
  read -r -p "Business owner [${OWNER:-}]: " SYS_OWNER || SYS_OWNER=""
  SYS_OWNER="${SYS_OWNER:-$OWNER}"
  SYSTEMS=$((SYSTEMS+1))
  [ "$DECISION" = 2 ] || [ "$DATA" = 2 ] && FINDINGS=$((FINDINGS+1))
  save_state
  audit "intake system=$SYS_NAME decision=$DECISION data=$DATA autonomy=$AUTO human=$HUMAN"
  printf '%b[SUCCESS] AI system added to inventory.%b\n' "${GREEN}" "$RESET"
}

risk_form() {
  [ -n "${CONSENT:-}" ] || onboarding
  printf '\n%bRisk & Compliance Follow-up%b\n' "${CYAN}${BOLD}" "$RESET"
  nav_select 'Evidence status:' 'Implemented' 'Partial' 'Not implemented' 'Unknown' 'Needs legal review'
  STATUS=$SELECTED_INDEX
  nav_select 'Finding severity:' 'Critical' 'High' 'Medium' 'Low' 'Unknown'
  SEVERITY=$SELECTED_INDEX
  read -r -p "Risk description: " RISK || RISK=""
  read -r -p "Recommended corrective action: " ACTION || ACTION=""
  read -r -p "Remediation owner [${OWNER:-}]: " RISK_OWNER || RISK_OWNER=""
  RISK_OWNER="${RISK_OWNER:-$OWNER}"
  read -r -p "Target date [Not set]: " DUE || DUE=""
  DUE="${DUE:-Not set}"
  FINDINGS=$((FINDINGS+1)); save_state
  audit "risk status=$STATUS severity=$SEVERITY owner=$RISK_OWNER due=$DUE"
  printf '%b[SUCCESS] Risk recorded. Action: %s%b\n' "${GREEN}" "$ACTION" "$RESET"
}

report_form() {
  [ -n "${CONSENT:-}" ] || onboarding
  local stamp file
  stamp="$(date +%Y%m%d-%H%M%S)"
  file="$REPORT_DIR/governai-report-$stamp.csv"
  {
    printf 'Section,Field,Value\n'
    printf 'Assessment,Organization,%s\n' "${ORG:-}"
    printf 'Assessment,Name,%s\n' "${ASSESSMENT:-}"
    printf 'Assessment,Profile,%s\n' "${PROFILE:-}"
    printf 'Assessment,Permission,%s\n' "${PERMISSION:-}"
    printf 'Assessment,Consent,%s\n' "${CONSENT:-}"
    printf 'Assessment,Compliance,%s\n' "${COMPLIANCE:-}"
    printf 'Assessment,Frameworks,%s\n' "${FRAMEWORKS:-}"
    printf 'Inventory,ToolsDetected,%s\n' "${TOOLS_DETECTED:-}"
    printf 'Inventory,ToolsSelected,%s\n' "${TOOLS_SELECTED:-}"
    printf 'Inventory,AISystems,%s\n' "${SYSTEMS:-0}"
    printf 'Summary,Findings,%s\n' "${FINDINGS:-0}"
    printf 'Scope,SelectedItems,%s\n' "${SELECTED_ITEMS:-}"
    printf 'CallToAction,Fix,Review findings with compliance owner; assign remediation owners; set target dates; verify frameworks coverage\n'
    printf 'Reminder,Status,Excel-compatible CSV - production version emits .xlsx multi-sheet\n'
  } > "$file"
  LAST_REPORT="$file"; save_state
  audit "report exported=$file"
  printf '%b[SUCCESS] Report generated: %s%b\n' "${GREEN}" "$file" "$RESET"
  printf '%bOpen with: agy /open @last-report%b\n' "${YELLOW}" "$RESET"
}

codescan_review() {
  local target="${1:-}"
  local script_dir
  script_dir="$(cd "$(dirname "$0")" && pwd)"
  target="${target#@}"
  if [ -z "$target" ] || [ ! -e "$target" ]; then
    printf '%b[codescan] Path not found: %s%b\n' "${RED}" "${target:-<empty>}" "$RESET"
    return 1
  fi
  if ! command -v python3 >/dev/null 2>&1; then
    printf '%b[codescan] python3 is required but was not found on PATH.%b\n' "${RED}" "$RESET"
    return 1
  fi
  local stamp json_out csv_out rc
  stamp="$(date +%Y%m%d-%H%M%S)"
  json_out="$REPORT_DIR/codescan-$stamp.json"
  csv_out="$REPORT_DIR/codescan-$stamp.csv"
  python3 "$script_dir/codescan.py" --path "$target" --policy "$script_dir/policy.json" --no-network --json-out "$json_out" --csv-out "$csv_out"
  rc=$?
  audit "codescan target=$target exit=$rc report=$json_out"
  case "$rc" in
    2) printf '%b[codescan] BLOCKED. Report: %s%b\n' "${RED}${BOLD}" "$json_out" "$RESET";;
    1) printf '%b[codescan] REVIEW REQUIRED. Report: %s%b\n' "${YELLOW}${BOLD}" "$json_out" "$RESET";;
    0) printf '%b[codescan] No sample policy matches. Report: %s%b\n' "${GREEN}" "$json_out" "$RESET";;
    *) printf '%b[codescan] Scan failed with exit %s.%b\n' "${RED}" "$rc" "$RESET";;
  esac
  return "$rc"
}

open_ref() {
  local ref="${1:-}"
  [ -n "$ref" ] || { printf 'Usage: /open @path|@alias|URL\n'; return 1; }
  ref="${ref#@}"
  case "$ref" in
    reports) ref="$REPORT_DIR";;
    audit-folder) ref="$STATE_DIR";;
    last-report) ref="${LAST_REPORT:-}";;
    last-codescan) ref="${LAST_CODESCAN:-}";;
    home) ref="$HOME";;
    desktop) ref="${USERPROFILE:-$HOME}/Desktop";;
    documents) ref="${USERPROFILE:-$HOME}/Documents";;
    downloads) ref="${USERPROFILE:-$HOME}/Downloads";;
    state) ref="$STATE_DIR";;
    chat) ref="$CHAT_LOG";;
    logs) ref="$AUDIT_LOG";;
  esac
  [ -n "$ref" ] || { printf 'No saved reference found.\n'; return 1; }
  if command -v cmd.exe >/dev/null 2>&1; then
    cmd.exe /c start "" "$ref" >/dev/null 2>&1 || true
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$ref" >/dev/null 2>&1 &
  else
    printf 'Resolved reference: %s\n' "$ref"
  fi
  audit "open reference=$ref"
  printf '%b[SUCCESS] Open request sent: %s%b\n' "${GREEN}" "$ref" "$RESET"
}

show_status() {
  printf '\n%bStatus%b\n' "${CYAN}${BOLD}" "$RESET"
  printf 'Organization : %s\n' "${ORG:-(not set)}"
  printf 'Assessment   : %s\n' "${ASSESSMENT:-(not set)}"
  printf 'Profile      : %s\n' "${PROFILE:-(not set)}"
  printf 'Permission   : %s\n' "${PERMISSION:-(not set)}"
  printf 'Consent      : %s\n' "${CONSENT:-(not set)}"
  printf 'Compliance   : %s\n' "${COMPLIANCE:-(not set)}"
  printf 'Frameworks   : %s\n' "${FRAMEWORKS:-(not set)}"
  printf 'Tools scope  : %s\n' "${TOOLS_SELECTED:-(none)}"
  printf 'AI systems   : %s\n' "${SYSTEMS:-0}"
  printf 'Findings     : %s\n' "${FINDINGS:-0}"
  printf 'Last report  : %s\n' "${LAST_REPORT:-(none)}"
}

show_inventory() {
  printf '\n%bInventory%b\n' "${CYAN}${BOLD}" "$RESET"
  printf 'Detected: %s\n' "${TOOLS_DETECTED:-(none)}"
  printf 'Selected: %s\n' "${TOOLS_SELECTED:-(none)}"
  printf 'Systems : %s\n' "${SYSTEMS:-0}"
}

show_logs() {
  printf '\n%bAudit Log%b\n' "${CYAN}${BOLD}" "$RESET"
  [ -f "$AUDIT_LOG" ] && cat "$AUDIT_LOG" || printf '(no events)\n'
}

doctor() {
  printf '\n%bDoctor%b\n' "${CYAN}${BOLD}" "$RESET"
  printf 'State dir : %s\n' "$STATE_DIR"
  [ -d "$STATE_DIR" ] && printf '%bOK state dir%b\n' "${GREEN}" "$RESET" || printf '%bMISSING state dir%b\n' "${RED}" "$RESET"
  printf 'Admin     : '; is_admin && printf '%bYES%b\n' "${GREEN}" "$RESET" || printf '%bNO (recommended)%b\n' "${YELLOW}" "$RESET"
  printf 'Shell     : %s\n' "${BASH_VERSION:-unknown}"
  printf 'OS        : %s\n' "${OSTYPE:-unknown}"
}

# ---------- Chat box ----------
chat_box() {
  printf '\n%bOpen Chat%b  %b(type @path or /command, /back to return)%b\n' "${CYAN}${BOLD}" "$RESET" "$DIM"
  local msg
  while true; do
    printf '%bchat>%b ' "${MAGENTA}${BOLD}" "$RESET"
    read -r msg || return 0
    chatlog "msg=$msg"
    case "$msg" in
      /back|/exit|/quit) return 0;;
      /setup) setup_form;;
      /intake) intake_form;;
      /risk) risk_form;;
      /inventory) show_inventory;;
      /status) show_status;;
      /export|/report) report_form;;
      /open*) open_ref "${msg#/open }";;
      /logs) show_logs;;
      /codescan*) codescan_review "${msg#/codescan }";;
      /doctor) doctor;;
      /help) help_text;;
      /scan) scan_programs; show_inventory;;
      /agy|/close) printf 'Use /quit or type agy cli to close.\n';;
      @*) open_ref "$msg";;
      '') ;;
      *) printf '%bUnknown. Try /help or @path%b\n' "${YELLOW}" "$RESET";;
    esac
  done
}

help_text() {
  cat <<'EOF'
GovernAI CLI - Antigravity
Slash commands:
  /setup       Run onboarding setup
  /intake      Add an AI system
  /risk        Add a risk/compliance finding
  /inventory   Show inventory & detected tools
  /status      Show saved state
  /open @ref   Open path/alias/URL (reports, last-report, home, desktop, documents, downloads, audit-folder, state, chat, logs)
  /export      Generate Excel-compatible CSV report
  /scan        Re-scan installed programs
  /logs        Show audit log
  /codescan @path   Scan generated code for risky/non-compliant third-party packages & APIs
  /doctor      Health check
  /chat        Open chat box
  /help        This help
  /quit|agy cli Close application

Examples:
  agy /open @"C:/Projects/AI"
  agy /intake
  agy /export
EOF
}

# ---------- Menu sections ----------
menu_home() {
  nav_select 'Home' 'Dashboard' 'Status overview' 'Quick intake' 'Open chat' 'Back'
  case "$SELECTED_INDEX" in
    0) show_status;;
    1) show_status;;
    2) intake_form;;
    3) chat_box;;
  esac
}

menu_setup() {
  nav_select 'Setup' 'Team' 'Framework' 'Licenses' 'Settings' 'Run onboarding' 'Back'
  case "$SELECTED_INDEX" in
    0) printf 'Team module (mock)\n';;
    1) printf 'Frameworks: %s\n' "${FRAMEWORKS:-none}";;
    2) printf 'Licenses (mock)\n';;
    3) printf 'Settings (mock)\n';;
    4) onboarding;;
  esac
}

menu_governance() {
  nav_select 'Governance' 'Intake' 'Inventory' 'Layers' 'Agents' 'Playbooks' 'Lifecycle' 'Risks' 'Org Structure' 'AIAs' 'Checklists' 'Policies' 'Back'
  case "$SELECTED_INDEX" in
    0) intake_form;;
    1) show_inventory;;
    2) printf 'Layers (mock)\n';;
    3) printf 'Agents: %s\n' "${TOOLS_SELECTED:-none}";;
    4) printf 'Playbooks (mock)\n';;
    5) printf 'Lifecycle (mock)\n';;
    6) risk_form;;
    7) printf 'Org: %s | Owner: %s\n' "${ORG:-unset}" "${OWNER:-unset}";;
    8) printf 'AIAs (mock)\n';;
    9) risk_form;;
    10) printf 'Policies (mock)\n';;
  esac
}

menu_frameworks() {
  nav_select 'Frameworks' 'EU AI Act' 'ISO 42001' 'ISO 27001' 'Agent Runtime Gov' 'COBIT' 'DCAM' 'OECD' 'UNESCO' 'EIF' 'NIST AI RMF' 'NYC LL 144' 'Colorado AI Act' 'HIPAA' 'GLBA' 'ECOA/FCRA' 'FERPA' 'NAIC' 'SOX' 'Back'
  local fw=("EU AI Act" "ISO 42001" "ISO 27001" "Agent Runtime Gov" "COBIT" "DCAM" "OECD" "UNESCO" "EIF" "NIST AI RMF" "NYC LL 144" "Colorado AI Act" "HIPAA" "GLBA" "ECOA/FCRA" "FERPA" "NAIC" "SOX")
  printf 'Framework: %s\n' "${fw[$SELECTED_INDEX]}"
}

menu_operations() {
  nav_select 'Operations' 'Analytics' 'Graph' 'Runtime Gov' 'Monitoring' 'MLOps' 'Data Gov' 'Quality' 'Behavior' 'Security' 'Security Audits' 'Controls' 'Board' 'Export' 'Miscellaneous' 'Back'
  case "$SELECTED_INDEX" in
    0) printf 'Analytics (mock)\n';;
    1) printf 'Graph (mock)\n';;
    2) printf 'Runtime Gov (mock)\n';;
    3) printf 'Monitoring (mock)\n';;
    4) printf 'MLOps (mock)\n';;
    5) printf 'Data Gov (mock)\n';;
    6) printf 'Quality (mock)\n';;
    7) printf 'Behavior (mock)\n';;
    8) printf 'Security (mock)\n';;
    9) risk_form;;
    10) printf 'Controls (mock)\n';;
    11) printf 'Board (mock)\n';;
    12) report_form;;
    13) printf 'Miscellaneous (mock)\n';;
  esac
}

menu_support() {
  nav_select 'Support' 'Support' 'Coverage' 'Acronyms' 'Features' 'Doctor' 'Help' 'Back'
  case "$SELECTED_INDEX" in
    0) printf 'Support: contact@governai.local\n';;
    1) printf 'Coverage: NIST AI RMF, ISO 42001, EU AI Act, NYC LL 144, Colorado AI Act, HIPAA, GLBA, ECOA/FCRA, FERPA, NAIC, SOX\n';;
    2) printf 'Acronyms: AIA=AI Assessment, RMF=Risk Mgmt Framework, RM=Read-only mode\n';;
    3) printf 'Features: inventory, risks, audits, reports, chat, scanner\n';;
    4) doctor;;
    5) help_text;;
  esac
}

menu_top() {
  local opts=("Home" "Setup" "Governance" "Frameworks" "Operations" "Support" "Open Chat" "Export Report" "Scan Programs" "Codescan Generated Code" "Open @ref" "Audit Log" "Doctor" "Help" "Quit (agy cli)")
  while true; do
    nav_select "Main menu (↑/↓ move, Space/Enter select):" "${opts[@]}"
    case "$SELECTED_INDEX" in
      0) menu_home;;
      1) menu_setup;;
      2) menu_governance;;
      3) menu_frameworks;;
      4) menu_operations;;
      5) menu_support;;
      6) chat_box;;
      7) report_form;;
      8) scan_programs; show_inventory;;
      9) read -r -p 'Path or @path to scan: ' cref; codescan_review "$cref";;
      10) read -r -p 'Enter @path or @alias: ' ref; open_ref "$ref";;
      11) show_logs;;
      12) doctor;;
      13) help_text;;
      14) audit "app closed by user"; printf '%bGoodbye from %s.%b\n' "${GREEN}" "$APP_NAME" "$RESET"; exit 0;;
    esac
  done
}

dispatch() {
  local cmd="${1:-}"; shift || true
  case "$cmd" in
    /setup|setup) onboarding;;
    /intake|intake) intake_form;;
    /risk|risk|/checklist|checklist) risk_form;;
    /inventory|inventory) show_inventory;;
    /status|status) show_status;;
    /open|open) open_ref "${1:-}";;
    /audit|audit) [ -n "${1:-}" ] && printf 'Audit scope: %s\n' "${1#@}"; intake_form;;
    /export|export|/report|report) report_form;;
    /logs|logs) show_logs;;
    /scan|scan) scan_programs; show_inventory;;
    /codescan|codescan) codescan_review "${1:-}";;
    /doctor|doctor) doctor;;
    /chat|chat) chat_box;;
    /help|help|-h|--help) help_text;;
    /agy|/quit|/exit|agy) audit "app closed"; printf 'Closing %s...\n' "$APP_NAME"; exit 0;;
    '') menu_top;;
    *) printf '%bUnknown: %s%b\n' "${RED}" "$cmd" "$RESET"; help_text; return 1;;
  esac
}

# ---------- Installer ----------
install_self() {
  animate_logo
  printf '%bInstalling %s (Antigravity)%b\n' "${CYAN}${BOLD}" "$APP_NAME" "$RESET"
  admin_note
  spinner 'Checking shell compatibility'
  spinner 'Creating state directories'
  spinner 'Registering mock commands (agy / gai)'
  spinner 'Building framework index'
  spinner 'Provisioning audit trail'
  local target="/usr/local/bin/agy"
  if [ -w "/usr/local/bin" ] 2>/dev/null; then
    ln -sf "$0" "$target" 2>/dev/null && printf '%bLinked: %s%b\n' "${GREEN}" "$target" "$RESET"
  else
    printf '%bTip: run as Administrator to register agy system-wide.%b\n' "${YELLOW}" "$RESET"
    printf '%bOr add alias: alias agy="bash %s"%b\n' "${YELLOW}" "$0" "$RESET"
  fi
  printf '%b[SUCCESS] %s installed locally.%b\n' "${GREEN}" "$APP_NAME" "$RESET"
  audit "install completed"
}

# ---------- Entry ----------
load_state
trap 'printf "%b" "${ESC}[?25h";' EXIT
if [ "$#" -gt 0 ]; then
  case "$1" in
    --install|install) install_self; exit 0;;
    --help|-h) help_text; exit 0;;
    *) dispatch "$@";;
  esac
else
  # Onboarding required on first run
  if [ -z "${CONSENT:-}" ]; then
    onboarding
  else
    animate_logo
    printf '%bWelcome back to %s v%s.%b\n' "${GREEN}${BOLD}" "$APP_NAME" "$VERSION" "$RESET"
    printf 'Org: %s | Profile: %s | Systems: %s | Findings: %s\n' "${ORG:-unset}" "${PROFILE:-unset}" "${SYSTEMS:-0}" "${FINDINGS:-0}"
  fi
  menu_top
fi