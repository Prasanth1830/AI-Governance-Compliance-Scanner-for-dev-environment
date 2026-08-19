#!/usr/bin/env python3
"""Small, deterministic demo scanner for generated Python code."""

from __future__ import annotations

import argparse
import ast
import csv
import json
import re
import sys
from dataclasses import asdict, dataclass
from pathlib import Path


@dataclass
class Finding:
    kind: str
    subject: str
    severity: str
    consequence: str
    recommendation: str
    source: str
    seen_in: list[str]


URL_RE = re.compile(r"https?://([A-Za-z0-9._-]+)", re.IGNORECASE)
IMPORT_TO_PACKAGE = {"Crypto": "pycrypto", "yaml": "PyYAML", "requests": "requests"}
SEVERITY_ORDER = {"CRITICAL": 0, "HIGH": 1, "MEDIUM": 2, "LOW": 3, "INFO": 4}


def python_files(root: Path) -> list[Path]:
    if root.is_file() and root.suffix == ".py":
        return [root]
    return sorted(path for path in root.rglob("*.py") if path.is_file())


def discover(root: Path) -> tuple[dict[str, list[str]], dict[str, list[str]]]:
    packages: dict[str, list[str]] = {}
    domains: dict[str, list[str]] = {}
    for path in python_files(root):
        try:
            text = path.read_text(encoding="utf-8-sig", errors="ignore")
            tree = ast.parse(text, filename=str(path))
        except (OSError, SyntaxError):
            continue
        for node in ast.walk(tree):
            names: list[str] = []
            if isinstance(node, ast.Import):
                names = [alias.name.split(".")[0] for alias in node.names]
            elif isinstance(node, ast.ImportFrom) and node.level == 0 and node.module:
                names = [node.module.split(".")[0]]
            for name in names:
                package = IMPORT_TO_PACKAGE.get(name, name)
                if package not in sys.stdlib_module_names:
                    packages.setdefault(package, []).append(str(path))
        for domain in URL_RE.findall(text):
            domains.setdefault(domain.lower(), []).append(str(path))

    if root.is_dir():
        requirement_files = root.rglob("requirements*.txt")
    elif root.name.startswith("requirements"):
        requirement_files = [root]
    else:
        requirement_files = []
    for requirement_file in requirement_files:
        try:
            lines = requirement_file.read_text(encoding="utf-8", errors="ignore").splitlines()
        except OSError:
            continue
        for line in lines:
            match = re.match(r"^\s*([A-Za-z0-9_.-]+)", line)
            if match and not line.lstrip().startswith("#"):
                packages.setdefault(match.group(1), []).append(str(requirement_file))
    return packages, domains


def load_policy(path: Path) -> dict:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        print(f"[codescan] policy error: {error}", file=sys.stderr)
        raise SystemExit(3)


def evaluate(packages: dict[str, list[str]], domains: dict[str, list[str]], policy: dict) -> list[Finding]:
    findings: list[Finding] = []
    package_rules = {entry["name"].lower(): entry for entry in policy.get("denylisted_packages", [])}
    domain_rules = {entry["domain"].lower(): entry for entry in policy.get("denylisted_domains", [])}
    for package, files in packages.items():
        rule = package_rules.get(package.lower())
        if rule:
            findings.append(Finding("package", package, rule["severity"], rule["consequence"], rule["recommendation"], "policy.json", files))
    for domain, files in domains.items():
        rule = domain_rules.get(domain.lower())
        if rule:
            findings.append(Finding("API domain", domain, rule["severity"], rule["consequence"], rule["recommendation"], "policy.json", files))
    return sorted(findings, key=lambda finding: SEVERITY_ORDER.get(finding.severity, 99))


def print_report(root: Path, packages: dict[str, list[str]], domains: dict[str, list[str]], findings: list[Finding]) -> None:
    print("\n--- CODESCAN SAMPLE COMPLIANCE REVIEW ---")
    print(f"Scanned: {root}")
    print(f"Packages detected: {', '.join(sorted(packages)) or '(none)'}")
    print(f"API domains detected: {', '.join(sorted(domains)) or '(none)'}")
    if not findings:
        print("[OK] No sample policy matches found.")
        return
    for finding in findings:
        print(f"[{finding.severity}] {finding.kind}: {finding.subject}")
        print(f"  Consequence: {finding.consequence}")
        print(f"  Recommendation: {finding.recommendation}")
        print(f"  Found in: {', '.join(finding.seen_in)}")
        print(f"  Source: {finding.source}")
    critical = any(finding.severity == "CRITICAL" for finding in findings)
    high = any(finding.severity == "HIGH" for finding in findings)
    print("[BLOCKED] Critical sample findings detected." if critical else "[REVIEW REQUIRED] High sample findings detected.")


def main() -> int:
    parser = argparse.ArgumentParser(description="Scan generated Python code against sample package/API policy data.")
    parser.add_argument("--path", required=True, help="Python file or codebase directory to scan")
    parser.add_argument("--policy", default=str(Path(__file__).with_name("policy.json")))
    parser.add_argument("--no-network", action="store_true", help="Accepted for CLI compatibility; demo mode is local-only")
    parser.add_argument("--json-out")
    parser.add_argument("--csv-out")
    args = parser.parse_args()
    root = Path(args.path)
    if not root.exists():
        print(f"[codescan] path not found: {root}", file=sys.stderr)
        return 3
    packages, domains = discover(root)
    findings = evaluate(packages, domains, load_policy(Path(args.policy)))
    print_report(root, packages, domains, findings)
    report = {"scanned_path": str(root), "packages_found": sorted(packages), "domains_found": sorted(domains), "findings": [asdict(finding) for finding in findings]}
    if args.json_out:
        Path(args.json_out).write_text(json.dumps(report, indent=2), encoding="utf-8")
        print(f"JSON report: {args.json_out}")
    if args.csv_out:
        with Path(args.csv_out).open("w", newline="", encoding="utf-8") as handle:
            writer = csv.DictWriter(handle, fieldnames=["kind", "subject", "severity", "consequence", "recommendation", "source", "seen_in"])
            writer.writeheader()
            for finding in findings:
                row = asdict(finding)
                row["seen_in"] = "; ".join(row["seen_in"])
                writer.writerow(row)
        print(f"CSV report: {args.csv_out}")
    if any(finding.severity == "CRITICAL" for finding in findings):
        return 2
    if any(finding.severity == "HIGH" for finding in findings):
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
