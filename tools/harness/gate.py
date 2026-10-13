#!/usr/bin/env python3
"""Check an Implementation Unit contract, then run its validation commands.

A unit is not VALIDATED unless this process exits 0.
Use --check-contract to skip Godot and the other declared commands.
"""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
UNITS = ROOT / "docs" / "technical" / "implementation-units"

REQUIRED_SECTIONS = (
    "## ID",
    "## Title",
    "## Status",
    "## Objective",
    "## Scope",
    "## Out of Scope",
    "## Dependencies",
    "## Acceptance Criteria",
    "## Tests Required",
    "## Validation",
    "## Risk",
    "## Write Scope",
    "### Required Documents",
)

STATUSES = {
    "BACKLOG",
    "READY",
    "IN_PROGRESS",
    "BLOCKED",
    "IMPLEMENTED",
    "TESTED",
    "VALIDATED",
    "REVIEWING",
    "DONE",
}

RISKS = {"LOW", "MEDIUM", "HIGH"}

ALLOWED_COMMANDS = (
    re.compile(r"^godot(?:\s|$)"),
    re.compile(r"^python3 tools/harness/check_domain_boundaries\.py$"),
)


def find_unit(unit_id: str) -> Path:
    matches = sorted(UNITS.glob(f"{unit_id}-*.md"))
    exact = [path for path in matches if path.name.startswith(unit_id + "-")]
    if len(exact) != 1:
        raise SystemExit(f"expected one contract for {unit_id}, found {len(exact)}")
    return exact[0]


def section_body(text: str, heading: str) -> str:
    marker = heading + "\n"
    start = text.find(marker)
    if start < 0:
        return ""
    rest = text[start + len(marker) :]
    next_heading = re.search(r"\n#{2,3} ", rest)
    if next_heading is None:
        return rest
    return rest[: next_heading.start()]


def validation_commands(text: str) -> list[str]:
    body = section_body(text, "## Validation")
    fenced = re.search(r"```(?:text)?\n(.*?)```", body, re.DOTALL)
    if fenced is None:
        return []
    return [line.strip() for line in fenced.group(1).splitlines() if line.strip()]


def check_contract(path: Path, text: str, unit_id: str) -> list[str]:
    errors: list[str] = []
    for section in REQUIRED_SECTIONS:
        if section not in text:
            errors.append(f"missing section: {section}")

    if not path.name.startswith(unit_id + "-"):
        errors.append(f"file name must start with {unit_id}-")

    id_body = section_body(text, "## ID").strip()
    if id_body != unit_id:
        errors.append(f"## ID is {id_body!r}, expected {unit_id}")

    status = section_body(text, "## Status").strip()
    if status not in STATUSES:
        errors.append(f"## Status must be one of {sorted(STATUSES)}, found {status!r}")

    risk = section_body(text, "## Risk").strip()
    if risk not in RISKS:
        errors.append(f"## Risk must be LOW, MEDIUM, or HIGH, found {risk!r}")

    if "Allowed:" not in section_body(text, "## Write Scope"):
        errors.append("## Write Scope must list Allowed:")

    commands = validation_commands(text)
    if not commands:
        errors.append("## Validation must contain a fenced command block")
    for command in commands:
        if not any(pattern.match(command) for pattern in ALLOWED_COMMANDS):
            errors.append(f"validation command is not allowed: {command}")

    return errors


def run_command(command: str) -> int:
    if command.startswith("godot"):
        binary = os.environ.get("GODOT", "godot")
        if shutil.which(binary) is None:
            print(f"FAIL {command}")
            print(f"Godot binary not found: {binary}. Set GODOT to the Godot 4.7 executable.")
            return 127
        argv = [binary, *command.split()[1:]]
    else:
        argv = command.split()

    print(f"RUN {' '.join(argv)}")
    completed = subprocess.run(argv, cwd=ROOT, check=False)
    if completed.returncode != 0:
        print(f"FAIL {command} (exit {completed.returncode})")
    return completed.returncode


def main() -> int:
    sys.stdout.reconfigure(line_buffering=True)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("unit_id", help="Implementation Unit id, for example IU-001")
    parser.add_argument(
        "--check-contract",
        action="store_true",
        help="Validate the markdown contract and do not run its commands",
    )
    args = parser.parse_args()

    path = find_unit(args.unit_id)
    text = path.read_text(encoding="utf-8")
    errors = check_contract(path, text, args.unit_id)
    if errors:
        print(f"contract: FAIL {path.relative_to(ROOT)}")
        for error in errors:
            print(f"- {error}")
        return 1

    print(f"contract: PASS {path.relative_to(ROOT)}")
    if args.check_contract:
        return 0

    for command in validation_commands(text):
        code = run_command(command)
        if code != 0:
            return code

    print(f"gate: PASS {args.unit_id}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
