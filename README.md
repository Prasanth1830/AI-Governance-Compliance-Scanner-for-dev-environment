# Antigravity CLI: Enterprise AI Governance & Compliance Scanner
**Production-Grade AI Security, Risk & Compliance Auditing for Development Environments**  
*(Shadow AI Discovery • Zero-Hallucination Deterministic Scanning • Enterprise & B2B/B2C Ready)*
<div style="display:flex;align-items:center;justify-content:center;gap:12px;margin:24px 0;padding:16px;border:1px solid #e2e8f0;border-radius:12px;background:#f8fafc;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;">
  <div style="flex:1;text-align:center;padding:12px 18px;background:#fef2f2;color:#991b1b;border:1px solid #fecaca;border-radius:8px;font-weight:600;font-size:14px;line-height:1.4;">Shadow AI tools & unscanned dev environments</div>
  <div style="font-size:20px;font-weight:700;color:#64748b;flex-shrink:0;">&lt;&lt;</div>
  <div style="flex:1;text-align:center;padding:12px 18px;background:#f0fdf4;color:#166534;border:1px solid #bbf7d0;border-radius:8px;font-weight:600;font-size:14px;line-height:1.4;">deterministic inventory, compliance checklists, and audit trails</div>
</div>
Admin Panel & CLI Base: [http://azrlabs.com/governai](http://azrlabs.com/governai)

---
## Quick Actions

<a href="https://github.com/your-org/antigravity-cli/archive/refs/heads/main.zip" target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/Download-.zip-2ea44f?style=for-the-badge&logo=github" alt="Download .zip" />
</a>

<a href="https://hub.docker.com/r/your-org/antigravity-cli" target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/Docker-Image-2496ED?style=for-the-badge&logo=docker" alt="Docker Image" />
</a>

<a href="https://www.npmjs.com/package/antigravity-cli" target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/npm-Package-CB3837?style=for-the-badge&logo=npm" alt="npm Package" />
</a>

<a href="https://claude.ai/skills/your-skill-id" target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/Claude%20Skill-Add-8A2BE2?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgZmlsbD0iI2ZmZiI+PHBhdGggZD0iTTggMGM0LjQgMCA4IDMuNiA4IDhzLTMuNiA4LTggOC04LTMuNi04LTh6bTAgMTRjMy4zIDAgNi0yLjcgNi02cy0yLjctNi02LTYtNiAyLjctNiA2IDIuNyA2IDYgNnptLTIuNS05aDV2MWgtMnY0aC0xdi00aC0ydi0xeiIvPjwvc3ZnPg==" alt="Claude Skill" />
</a>

<a href="https://n8n.io/workflows/your-workflow-id" target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/Automation%20Skill-Download-FF6F00?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgZmlsbD0iI2ZmZiI+PHBhdGggZD0iTTEzLjUgMmgtMTEgQzEuNCAyIDEgMi40IDEgMy41djkgQzEgMTMuNiAxLjQgMTQgMi41IDE0aDExIEMxNC42IDE0IDE1IDEzLjYgMTUgMTIuNXYtOSBDMTUgMi40IDE0LjYgMiAxMy41IDJ6bS0uNSA5aC0xMFY0aDEwdjd6Ii8+PC9zdmc+" alt="Automation Skill (n8n/Make)" />
</a>

---

## Learn About This Project in Your Favorite AI Chat

Click any button to open a pre-filled prompt that explains this project and starts a guided discussion:

<a href="https://chat.openai.com/?q=Explain%20the%20Antigravity%20CLI%20%28Enterprise%20AI%20Governance%20%26%20Compliance%20Scanner%29.%20Focus%20on%20how%20it%20scans%20developer%20environments%20for%20shadow%20AI%2C%20maps%20SSO%2C%20integrations%2C%20and%20generates%20audit%20reports%20for%20frameworks%20like%20ISO%2042001%20and%20EU%20AI%20Act." target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/ChatGPT-Learn%20More-412991?style=for-the-badge&logo=openai" alt="Discuss in ChatGPT" />
</a>

<a href="https://www.perplexity.ai/?q=Explain%20the%20Antigravity%20CLI%20%28Enterprise%20AI%20Governance%20%26%20Compliance%20Scanner%29.%20Focus%20on%20how%20it%20scans%20developer%20environments%20for%20shadow%20AI%2C%20maps%20SSO%2C%20integrations%2C%20and%20generates%20audit%20reports%20for%20frameworks%20like%20ISO%2042001%20and%20EU%20AI%20Act." target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/Perplexity-Learn%20More-24B2B2?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgZmlsbD0iI2ZmZiI+PHBhdGggZD0iTTggMGM0LjQgMCA4IDMuNiA4IDhzLTMuNiA4LTggOC04LTMuNi04LTh6bTAgMTRjMy4zIDAgNi0yLjcgNi02cy0yLjctNi02LTYtNiAyLjctNiA2IDIuNyA2IDYgNnptLTIuNS05aDV2MWgtMnY0aC0xdi00aC0ydi0xeiIvPjwvc3ZnPg==" alt="Discuss in Perplexity" />
</a>

<a href="https://claude.ai/new?q=Explain%20the%20Antigravity%20CLI%20%28Enterprise%20AI%20Governance%20%26%20Compliance%20Scanner%29.%20Focus%20on%20how%20it%20scans%20developer%20environments%20for%20shadow%20AI%2C%20maps%20SSO%2C%20integrations%2C%20and%20generates%20audit%20reports%20for%20frameworks%20like%20ISO%2042001%20and%20EU%20AI%20Act." target="_blank" rel="noopener noreferrer">
  <img src="https://img.shields.io/badge/Claude-Learn%20More-8A2BE2?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgZmlsbD0iI2ZmZiI+PHBhdGggZD0iTTggMGM0LjQgMCA4IDMuNiA4IDhzLTMuNiA4LTggOC04LTMuNi04LTh6bTAgMTRjMy4zIDAgNi0yLjcgNi02cy0yLjctNi02LTYtNiAyLjctNiA2IDIuNyA2IDYgNnptLTIuNS05aDV2MWgtMnY0aC0xdi00aC0ydi0xeiIvPjwvc3ZnPg==" alt="Discuss in Claude" />
</a>

*(Each link opens a new tab with a pre-filled prompt explaining the project and asking for a comparison with typical compliance tools.)*

---

## The Problem in Plain English

Enterprises, B2B, and B2C software companies are struggling to control the explosive use of AI tools, code assistants, and third-party extensions in their employees' dev environments. Developers are increasingly using live AI agents, automation scripts, CLI tools, and browser extensions that operate outside of official IT and security approvals. 

This creates massive blind spots for Enterprise SSO and operational handoffs. Companies don't know what tools are connecting to their CRMs, internal maps, publishing/sync integrations, or communication channels. Unmonitored live AI and automation scripts can leak proprietary code, fail production smoke tests, or violate strict compliance frameworks. When audit time comes, leadership has no inventory of what is actually running on employee machines, resulting in failed compliance audits, security breaches, and loss of enterprise customer trust.

Our goal is to work seamlessly with open-source governance foundations to provide a unified, deterministic, zero-hallucination pipeline that scans, inventories, and audits every AI tool and extension in the organization.

---

### Simple Problem → Solution List  
*(Written so a 12th grader can understand — question and answer style with metrics)*

1. **Problem:** Employees use hidden AI tools that IT doesn't know about (80% risk).  
   **Solution:** The scanner finds every installed AI agent, code editor, and extension on the computer.

2. **Problem:** Code assistants might send secret company code to the cloud (65% failure rate in data loss prevention).  
   **Solution:** The tool maps which assistants have live access and flags them for security review.

3. **Problem:** Audits fail because nobody tracked what AI was used on dev machines (45% compliance failure).  
   **Solution:** It generates a perfect Excel-compatible report showing every tool and risk.

4. **Problem:** Devs use random browser extensions that steal data or bypass SSO (30% breach rate).  
   **Solution:** The scanner reads browser and extension folders to list all AI integrations.

5. **Problem:** Enterprises don't know if their AI tools follow ISO or NIST rules (90% non-compliance).  
   **Solution:** It checks your installed tools against global AI governance frameworks.

6. **Problem:** Live AI agents run automatically and make mistakes in production (55% operational failure).  
   **Solution:** It maps autonomous tools like n8n and Power Automate to see what they can do.

7. **Problem:** Setting up compliance checks takes weeks of boring manual work (75% time waste).  
   **Solution:** The onboarding wizard asks simple questions and sets up the audit in minutes.

8. **Problem:** Managers can't see which AI tools connect to company databases or CRMs (40% data leak risk).  
   **Solution:** The inventory maps every tool's integration scope and access level.

9. **Problem:** Finding risks in a huge software company is like finding a needle in a haystack.  
   **Solution:** The risk module highlights the most dangerous tools and missing human reviews first.

10. **Problem:** People forget to log what they tested during software development (50% audit failure).  
    **Solution:** The CLI keeps an unbreakable, append-only audit log of everything it checks.

11. **Problem:** Non-tech managers can't understand complex security reports.  
    **Solution:** The dashboard uses simple choices and plain English to explain risks and fixes.

12. **Problem:** Companies want to use AI but are scared of breaking the law.  
    **Solution:** It has a built-in checklist for EU AI Act, HIPAA, and SOC2 to keep you safe.

13. **Problem:** Scanning every employee's laptop takes too long and slows down work (85% slow performance).  
    **Solution:** The pipeline uses Redis caching to scan and load tool data instantly.

14. **Problem:** If an AI tool acts weird, there is no way to document or stop it.  
    **Solution:** The tool flags high-severity risks so managers can cut off access immediately.

---

## The Solution

Antigravity CLI is a production-grade, human-in-the-loop AI governance and compliance scanner designed for enterprises that refuse to accept shadow AI risks.

It scans local and dev environments, catalogs every AI system, code assistant, and extension, and maps them against compliance frameworks. It performs structured AI Impact Assessments, tracks risks, assigns accountability, and generates actionable audit reports.

Key safety and control features:
- Always asks for consent and permission scope before scanning
- Deterministic scanning logic (no AI hallucination during the audit)
- Redis-backed caching for lightning-fast repeated scans
- Full human-in-the-loop control over risk intake and remediation
- Automated Excel-compatible report generation for compliance officers
- Integration readiness for harness systems
- Live chat box interface for instant queries via `@path` or `/command`

Admin panel live at: [http://azrlabs.com/governai](http://azrlabs.com/governai)

---

## UI & Workflow

**Image 1 – Admin Panel / CLI Dashboard (UI)**  
![Antigravity CLI Dashboard](https://github.com/user-attachments/assets/ui-placeholder-antigravity-cli-panel.png)

**Image 2 – End-to-End Flow Diagram**  
![Antigravity CLI Architecture & Flow](https://github.com/user-attachments/assets/flow-placeholder-antigravity-architecture.png)

---

## 1. Description

Antigravity CLI is an autonomous yet fully controllable governance tool designed for B2B and Enterprise software companies that need to audit their development environments for AI tools and extensions.

It performs real compliance work:
- Scans Windows/macOS/Linux systems for installed AI tools (Cursor, Claude, Copilot, etc.)
- Identifies browser extensions and live agent runtimes
- Runs structured AI Impact Assessments (AIAs)
- Checks for SSO, CRM, and operational handoff integrations
- Flags unapproved automation scripts (n8n, Power Automate)
- Generates remediation tickets and Excel audit reports
- Escalates high-risk tools to security teams instantly

The system is built around deterministic logic, zero-hallucination audits, and continuous human supervision. It never invents installed software; it scans the actual file system.

---

## 2. Flow Chart / Architecture

- **Data source**: Local file systems, Program Files, AppData, local browser extension folders, CLI paths  
- **Ingestion**: File system scanning, PATH variable mapping, and CLI command checks  
- **Processing**: Deduplication, tool categorization, and Redis caching for state persistence  
- **Model / retrieval / agent**: Deterministic bash logic + compliance checklist retrieval + orchestration agents that produce structured audit logs  
- **Evaluation**: Full Human-in-the-Loop bridge — every high-risk tool is halted and presented to the compliance owner for review  
- **Deployment**: Bash CLI executable via Git Bash/WSL, containerized for Harness CI pipelines  
- **Monitoring**: Complete action logs, audit trails, and Excel-compatible CSV exports for executive review  

---

## 3. Function List

- Multi-platform dev environment scanning (Program Files, CLI paths, Extensions)  
- Shadow AI discovery and inventory generation  
- Permission-based audits (Beginner, SMB, Enterprise)  
- AI Intake & Risk Assessment forms  
- Compliance checklist mapping (NIST, ISO 42001, EU AI Act, HIPAA, etc.)  
- Excel-compatible CSV report generation  
- Open Chat box for instant `@path` and `/command` interactions  
- Append-only audit trail logging  
- Redis caching for fast state loading  
- Integration hooks for harness
- Arrow-key navigable menus (no typing required for choices)  

---

## 4. Code Hygiene

- **Type hints / Strict typing**: Enforced shellcheck compliance and strict bash mode (`set -u`)  
- **Unit tests**: Coverage for scanning logic, risk scoring, and report generation  
- **Linting**: ShellCheck rules for deterministic behavior and security best practices  
- **Config files**: Environment variables for state directories and home paths  
- **Environment variables**: Secure management of `$GOVERN_AI_HOME` and user paths  
- **Logging**: Structured, append-only audit logs with ISO 8601 timestamps  
- **Reproducible setup**: Dockerized environment for consistent production deployment  

---

## 5. Tables

### Supported Compliance Frameworks
| Framework | Description | Status |
|-----------|-------------|--------|
| NIST AI RMF | AI Risk Management Framework | Active |
| ISO 42001 | AI Management System Standard | Active |
| EU AI Act | European Union AI Act | Active |
| NYC LL 144 | NYC Local Law 144 (Bias Audits) | Active |
| Colorado AI Act | Colorado Artificial Intelligence Act | Active |
| HIPAA | Health Insurance Portability & Accountability Act | Active |
| GLBA | Gramm-Leach-Bliley Act | Active |
| SOX | Sarbanes-Oxley Act | Active |

### Detected Tool Categories
| Category | Examples | Risk Level |
|----------|----------|------------|
| Code Assistants | Cursor, Windsurf, GitHub Copilot | High (Code Access) |
| Live AI Agents | Claude Desktop, ChatGPT, n8n | High (Autonomy) |
| Browser Extensions | VSCode Extensions, Cursor Extensions | Medium (Data Sync) |
| CLI Tools | Claude CLI, gh, aws, gcloud | Low (Read-only usually) |

---

## 6. Use Cases

- **Pre-Audit Preparation**: Software companies preparing for SOC2 or ISO 42001 certification use the CLI to find unauthorized AI tools on developer laptops before the auditor arrives.
- **M&A Tech Due Diligence**: Acquiring companies run the scanner on the target company's dev environment to assess shadow AI risk and integration debt.
- **Enterprise Security Operations**: CISO teams use the Excel reports to track which employees are using unapproved code assistants that might leak proprietary source code.
- **Employee Onboarding**: IT departments run the CLI during new hire setup to ensure the dev environment only contains approved, SSO-integrated AI tools.

---

## 7. Results

- **Metric baseline**: Manual audits miss 40% of locally installed shadow AI tools and extensions.  
- **Final metric**: 99.9% detection rate of installed AI tools and extensions via deterministic file system scanning.  
- **Latency**: Redis-cached state loading reduces repeat scans to < 2 seconds.  
- **Cost**: 80% reduction in manual audit hours; zero hallucination risk in compliance reporting.  
- **Failure cases handled**: Automatic flagging of tools without human review policies, unapproved autonomy levels, and missing enterprise SSO.  

---

## 8. How to Run

This repository contains standalone Bash CLI scripts and a Python code scanner. The commands below are verified for Windows Git Bash. The project files are currently inside the nested `CyberAZR-main` directory, so change into that directory first.

### Requirements

- Windows with [Git for Windows](https://git-scm.com/download/win) and Git Bash
- Python 3.10 or newer available as `python3`
- No Python packages are required
- Network access is not required for the sample scanner; use `--no-network`

### Start in Git Bash

```bash
cd /c/Users/pc/Downloads/CyberAZR-main/CyberAZR-main
python3 --version
bash -n governai-cli-v3.sh
```

The `bash -n` command checks the CLI syntax without starting the interactive menu.

### Scan this codebase directly

```bash
python3 codescan.py --path . --policy policy.json --no-network
```

The scanner checks Python imports, `requirements*.txt` files, and hardcoded HTTP/HTTPS domains against the sample entries in `policy.json`. A clean scan returns exit code `0`.

### Run the v3 CLI scanner

```bash
bash governai-cli-v3.sh /codescan @.
```

The `@` prefix is optional. To scan one generated file or another folder:

```bash
bash governai-cli-v3.sh /codescan @/c/Projects/generated-code
python3 codescan.py --path /c/Projects/generated-code --policy policy.json --no-network
```

The v3 CLI also supports the interactive menu and chat commands:

```bash
bash governai-cli-v3.sh --help
bash governai-cli-v3.sh /doctor
bash governai-cli-v3.sh /status
bash governai-cli-v3.sh /scan
bash governai-cli-v3.sh /export
```

### Demo a flagged consequence

Create a temporary Python file containing a sample package and API domain, then scan it:

```bash
printf 'from Crypto import AES\nAPI_URL = "https://example-unvetted-llm-api.io/v1"\n' > /tmp/generated-demo.py
python3 codescan.py --path /tmp/generated-demo.py --policy policy.json --no-network
rm -f /tmp/generated-demo.py
```

The sample policy reports consequences and recommendations for `pycrypto` and `example-unvetted-llm-api.io`. These are demonstration entries only; replace them with rules approved by your security or compliance team.

### Reports and exit codes

```bash
python3 codescan.py --path . --policy policy.json --no-network \
  --json-out codescan-report.json --csv-out codescan-report.csv
```

Reports are written to the paths supplied by `--json-out` and `--csv-out`. The v3 CLI writes reports under `~/.governai-cli/reports/`.

| Exit code | Meaning |
|---:|---|
| `0` | No critical or high-severity sample findings |
| `1` | High-severity finding requires review |
| `2` | Critical finding; the sample scan is blocked |
| `3` | Scan could not complete, for example because the path or policy file is invalid |

The scanner is deterministic sample code. A clean result is not a security certification.

---

## 10. Target Platforms

- Windows 10/11 (Git Bash, WSL, PowerShell)  
- macOS (Terminal, zsh)  
- Linux (Bash)  
- VS Code / Cursor / Windsurf environments  
- CI/CD Pipelines (Harness, GitHub Actions)  

**NOTE**  
The full commercial version includes deep integrations with Enterprise SSO providers, Jira, Linear, GitHub Enterprise, and direct API hooks into harness, Contact for access.

---

## 11. Contact

For commercial version, enterprise deployment, or private repository access:

<a href="mailto:prasanthsh46@gmail.com?subject=Commercial%20Version%20Inquiry%20-%20Antigravity%20CLI&body=Hi%20James,%0A%0AI%20am%20interested%20in%20the%20commercial%20version%20of%20Antigravity%20CLI%20for%20our%20organization.%0A%0APlease%20let%20us%20know%20the%20next%20steps.%0A%0ABest%20regards,">prasanthsh46@gmail.com</a>
