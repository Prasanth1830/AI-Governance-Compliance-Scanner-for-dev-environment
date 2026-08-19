#!/usr/bin/env bash
# GovernAI CLI mock form for Windows via Git Bash or WSL.
# Usage: bash governai-cli.sh [slash-command] [arguments]
set -u

APP_NAME="GovernAI CLI Mock"
VERSION="0.1.0"
STATE_DIR="${GOVERN_AI_HOME:-$HOME/.governai-cli}"
DB_FILE="$STATE_DIR/state.env"
REPORT_DIR="$STATE_DIR/reports"
AUDIT_LOG="$STATE_DIR/audit.log"
mkdir -p "$REPORT_DIR"

ESC="$(printf '\033')"
RESET="${ESC}[0m"
CYAN="${ESC}[36m"
GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"
RED="${ESC}[31m"
DIM="${ESC}[2m"

LOGO='                      .__
_____  _______________|  | _____ \\_ |__   ______
\\__  \\ \___   /\\_  __ \\  | \\__  \\ | __ \\ /  ___/
 / __ \\_/    /  |  | \\/  |__/ __ \\| \\_\\ \\___ \\
(____  /_____ \\ |__|  |____(____  /___  /____  >
     \\/      \\/                 \\/    \\/     \\/'

now() { date '+%Y-%m-%dT%H:%M:%S%z'; }

load_state() {
  PROFILE="${PROFILE:-}"; PERMISSION="${PERMISSION:-}"; CONSENT="${CONSENT:-}";
  ORG="${ORG:-}"; ASSESSMENT="${ASSESSMENT:-}"; OWNER="${OWNER:-}";
  FRAMEWORKS="${FRAMEWORKS:-}"; SELECTED_ITEMS="${SELECTED_ITEMS:-}";
  SYSTEMS="${SYSTEMS:-0}"; FINDINGS="${FINDINGS:-0}";
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
LAST_REPORT=$(printf '%q' "${LAST_REPORT:-}")
EOF
}

audit() {
  printf '%s | %s\n' "$(now)" "$*" >> "$AUDIT_LOG"
}

pause() { read -r -p $'\nPress Enter to continue...' _ || true; }

choose() {
  local prompt="$1"; shift
  local answer
  while true; do
    printf '%s\n' "$prompt"
    local i=1
    for option in "$@"; do printf '  %d. %s\n' "$i" "$option"; i=$((i+1)); done
    read -r -p 'Enter choice: ' answer || exit 0
    if [[ "$answer" =~ ^[0-9]+$ ]] && [ "$answer" -ge 1 ] && [ "$answer" -le $# ]; then
      CHOICE="$answer"; return 0
    fi
    printf '%b\n' "${RED}Invalid choice. Enter a number from 1 to $#.$RESET"
  done
}

ask() { local prompt="$1" default="${2:-}"; read -r -p "$prompt${default:+ [$default]}: " value || exit 0; printf -v "$3" '%s' "${value:-$default}"; }

show_logo() { printf '%b\n' "${CYAN}$LOGO${RESET}"; }

spinner() {
  local label="$1"; local frames='|/-\\'; local i
  for i in {1..12}; do printf '\r%b%s %s%b' "$CYAN" "$label" "${frames:i%4:1}" "$RESET"; sleep 0.06; done
  printf '\r%b%s done%b\n' "$GREEN" "$label" "$RESET"
}

admin_note() {
  case "${OSTYPE:-}" in
    msys*|cygwin*|win32*)
      printf '%b\n' "${YELLOW}Note: launch Git Bash as Administrator for system-wide installation.${RESET}";;
  esac
}

install_mock() {
  show_logo; admin_note
  spinner 'Checking Windows-compatible shell'
  spinner 'Creating local state directories'
  spinner 'Registering mock commands'
  printf '%b\n' "${GREEN}[SUCCESS] $APP_NAME installed locally.${RESET}"
  printf '%s\n' "Run: bash governai-cli.sh or ./governai-cli.sh"
}

consent_form() {
  choose $'Consent is required before discovery.\nNo passwords, API keys, tokens, browser history, or private files will be collected.' \
    'Yes, continue with selected scope' 'No, exit' 'Review scope'
  case "$CHOICE" in
    1) CONSENT='yes'; audit 'consent=granted';;
    2) CONSENT='no'; audit 'consent=denied'; printf '%s\n' 'No data was collected.'; exit 0;;
    3) scope_form; consent_form;;
  esac
}

scope_form() {
  printf '\n%b\n' "${CYAN}Scope selection${RESET}"
  SELECTED_ITEMS=''
  while true; do
    read -r -p 'Add a file/folder with @, or /done: ' item || exit 0
    [ "$item" = '/done' ] && break
    case "$item" in
      @*)
        item="${item#@}"
        if [ -e "$item" ]; then
          SELECTED_ITEMS="${SELECTED_ITEMS}${SELECTED_ITEMS:+|}$item"
          printf '%b\n' "${GREEN}Added: $item$RESET"
        else
          printf '%b\n' "${YELLOW}Path does not exist yet; retained as a planned evidence reference: $item$RESET"
          SELECTED_ITEMS="${SELECTED_ITEMS}${SELECTED_ITEMS:+|}$item"
        fi;;
      *) printf '%b\n' "${YELLOW}Use @ before a path, for example @C:/Projects/AI or @./policies$RESET";;
    esac
  done
  audit "scope=${SELECTED_ITEMS:-empty}"
}

setup_form() {
  printf '\n%b\n' "${CYAN}First-run setup${RESET}"
  choose 'Select operating profile:' 'Beginner' 'SMB' 'Enterprise' 'Custom scope'
  PROFILE="$CHOICE"
  choose 'Select permission mode:' 'Read-only discovery' 'Guided audit' 'Organization-approved audit' 'Custom scope'
  PERMISSION="$CHOICE"
  ask 'Organization name' '' ORG
  ask 'Assessment name' "Assessment-$(date +%Y%m%d-%H%M%S)" ASSESSMENT
  ask 'Accountable owner' '' OWNER
  choose 'Select applicable frameworks:' 'NIST AI RMF' 'ISO/IEC 42001' 'EU AI Act' 'HIPAA' 'GLBA' 'ECOA/FCRA' 'FERPA' 'NAIC' 'SOX' 'None / choose later'
  FRAMEWORKS="$CHOICE"
  scope_form
  consent_form
  save_state
  audit 'setup completed profile=$PROFILE permission=$PERMISSION'
}

multi_select_tools() {
  printf '\n%b\n' "${CYAN}Detected-tool mock inventory${RESET}"
  printf '%s\n' 'Select all that apply by entering comma-separated numbers.'
  printf '%s\n' '  1. ChatGPT   2. Microsoft Copilot   3. Claude   4. Gemini'
  printf '%s\n' '  5. GitHub Copilot   6. Cursor   7. Windsurf   8. Ollama'
  printf '%s\n' '  9. n8n   10. Power Automate   11. Custom agent   12. None'
  read -r -p 'Selections: ' TOOLS || exit 0
  ask 'How many AI systems require owner assignment?' '0' SYSTEMS
  audit "tools=$TOOLS systems=$SYSTEMS"
}

intake_form() {
  [ -n "${CONSENT:-}" ] || setup_form
  printf '\n%b\n' "${CYAN}AI intake${RESET}"
  ask 'AI system name' '' SYS_NAME
  ask 'Business purpose' '' PURPOSE
  choose 'Does it affect decisions about people?' 'No' 'Unknown' 'Yes'
  DECISION="$CHOICE"
  choose 'Does it process personal or regulated data?' 'No' 'Unknown' 'Yes'
  DATA="$CHOICE"
  choose 'Does it operate autonomously?' 'No' 'Partially' 'Yes'
  AUTO="$CHOICE"
  choose 'Is human review defined?' 'No' 'Partially' 'Yes'
  HUMAN="$CHOICE"
  ask 'Business owner' "${OWNER:-}" SYS_OWNER
  SYSTEMS=$((SYSTEMS + 1))
  [ "$DECISION" = 3 ] || [ "$DATA" = 3 ] && FINDINGS=$((FINDINGS + 1))
  save_state; audit "intake system=$SYS_NAME purpose=$PURPOSE decision=$DECISION data=$DATA autonomy=$AUTO human_review=$HUMAN"
  printf '%b\n' "${GREEN}[SUCCESS] AI system added to the local inventory.${RESET}"
}

risk_form() {
  [ -n "${CONSENT:-}" ] || setup_form
  printf '\n%b\n' "${CYAN}Risk and compliance follow-up${RESET}"
  choose 'Overall evidence status:' 'Implemented' 'Partially implemented' 'Not implemented' 'Unknown' 'Needs legal review'
  STATUS="$CHOICE"
  choose 'Finding severity:' 'Critical' 'High' 'Medium' 'Low' 'Unknown'
  SEVERITY="$CHOICE"
  ask 'Risk description' '' RISK
  ask 'Recommended corrective action' '' ACTION
  ask 'Remediation owner' "${OWNER:-}" RISK_OWNER
  ask 'Target date' 'Not set' DUE
  FINDINGS=$((FINDINGS + 1)); save_state
  audit "risk status=$STATUS severity=$SEVERITY owner=$RISK_OWNER due=$DUE"
  printf '%b\n' "${GREEN}[SUCCESS] Risk finding recorded. Recommended action: $ACTION${RESET}"
}

report_form() {
  [ -n "${CONSENT:-}" ] || setup_form
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
    printf 'Assessment,FrameworkSelection,%s\n' "${FRAMEWORKS:-}"
    printf 'Summary,AI Systems,%s\n' "${SYSTEMS:-0}"
    printf 'Summary,Findings,%s\n' "${FINDINGS:-0}"
    printf 'Scope,SelectedItems,%s\n' "${SELECTED_ITEMS:-}"
    printf 'Reminder,Status,Mock report - review with qualified compliance personnel\n'
  } > "$file"
  LAST_REPORT="$file"; save_state; audit "report exported=$file"
  printf '%b\n' "${GREEN}[SUCCESS] Mock Excel-compatible CSV report generated: $file${RESET}"
  printf '%b\n' "${YELLOW}The production version will generate .xlsx with worksheets for inventory, risks, checklists, remediation, evidence, and audit trail.${RESET}"
}

open_ref() {
  local ref="${1:-}"
  [ -n "$ref" ] || { printf '%s\n' 'Usage: /open @path|@alias|URL'; return 1; }
  ref="${ref#@}"
  case "$ref" in
    reports) ref="$REPORT_DIR";;
    audit-folder) ref="$STATE_DIR";;
    last-report) ref="${LAST_REPORT:-}";;
    home) ref="$HOME";;
    desktop) ref="${USERPROFILE:-$HOME}/Desktop";;
    documents) ref="${USERPROFILE:-$HOME}/Documents";;
    downloads) ref="${USERPROFILE:-$HOME}/Downloads";;
  esac
  [ -n "$ref" ] || { printf '%s\n' 'No saved reference found.'; return 1; }
  if command -v cmd.exe >/dev/null 2>&1; then
    cmd.exe /c start '' "$ref" >/dev/null 2>&1 || true
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$ref" >/dev/null 2>&1 &
  else
    printf '%s\n' "Resolved reference: $ref"
  fi
  audit "open reference=$ref"
  printf '%b\n' "${GREEN}[SUCCESS] Open request sent: $ref${RESET}"
}

show_status() {
  printf '\n%b\n' "${CYAN}Status${RESET}"
  printf 'Organization: %s\nAssessment: %s\nProfile: %s\nPermission: %s\nConsent: %s\nAI systems: %s\nFindings: %s\nLast report: %s\n' \
    "${ORG:-(not set)}" "${ASSESSMENT:-(not set)}" "${PROFILE:-(not set)}" "${PERMISSION:-(not set)}" "${CONSENT:-(not set)}" "${SYSTEMS:-0}" "${FINDINGS:-0}" "${LAST_REPORT:-(none)}"
}

help_text() {
  cat <<'EOF'
GovernAI CLI mock commands:
  /setup                         Run the multi-choice setup form
  /intake                        Add an AI system through the mock intake form
  /risk                          Add a risk/compliance finding
  /inventory                     Show inventory count
  /status                        Show saved local state
  /open @path|@alias             Open a file, folder, URL, or saved location
  /export                        Generate an Excel-compatible CSV mock report
  /logs                          Show the local append-only audit log
  /doctor                        Check local folders and shell integration
  /help                          Show this help
  /exit                          Exit

Examples:
  gai /open @"C:/Projects/AI"
  gai /audit @./policies
  gai /intake @C:/Evidence
  gai /export
EOF
}

dispatch() {
  local cmd="${1:-}"; shift || true
  case "$cmd" in
    /setup|setup) setup_form;;
    /intake|intake) intake_form;;
    /risk|risk|/checklist|checklist) risk_form;;
    /inventory|inventory) multi_select_tools; show_status;;
    /status|status) show_status;;
    /open|open) open_ref "${1:-}";;
    /audit|audit) [ -n "${1:-}" ] && printf '%s\n' "Audit scope reference: ${1#@}"; intake_form;;
    /export|export|/report|report) report_form;;
    /logs|logs) [ -f "$AUDIT_LOG" ] && cat "$AUDIT_LOG" || printf '%s\n' 'No audit events yet.';;
    /doctor|doctor) printf 'State directory: %s\n' "$STATE_DIR"; [ -d "$STATE_DIR" ] && printf '%b\n' "${GREEN}OK${RESET}" || printf '%b\n' "${RED}Missing${RESET}";;
    /help|help|-h|--help) help_text;;
    /exit|exit) exit 0;;
    '') menu;;
    *) printf '%b\n' "${RED}Unknown command: $cmd${RESET}"; help_text; return 1;;
  esac
}

menu() {
  show_logo
  printf '%b\n' "${GREEN}$APP_NAME v$VERSION${RESET}"
  printf '%s\n' 'Use /help for slash commands. Use @ before files and folders.'
  while true; do
    choose $'\nMain menu:' 'Setup' 'AI intake' 'Risk/checklist' 'Inventory/tools' 'Status' 'Export report' 'Open file/folder' 'Audit log' 'Help' 'Exit'
    case "$CHOICE" in
      1) setup_form;; 2) intake_form;; 3) risk_form;; 4) multi_select_tools;; 5) show_status;;
      6) report_form;; 7) read -r -p 'Enter @path or @alias: ' ref; open_ref "$ref";;
      8) [ -f "$AUDIT_LOG" ] && cat "$AUDIT_LOG" || printf '%s\n' 'No audit events yet.';;
      9) help_text;; 10) exit 0;;
    esac
  done
}

load_state
if [ "$#" -gt 0 ]; then dispatch "$@"; else menu; fi
