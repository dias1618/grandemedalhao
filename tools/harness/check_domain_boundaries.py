#!/usr/bin/env python3
"""Fail when domain scripts depend on presentation or the scene tree."""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DOMAIN = ROOT / "domain"

FORBIDDEN = (
    "extends Node",
    "extends CharacterBody",
    "extends StaticBody",
    "extends AnimatableBody",
    "extends Area2D",
    "extends CanvasItem",
    "extends Control",
    "extends Sprite2D",
    "Input.",
    "change_scene",
    'preload("res://presentation',
    'preload("res://scenes',
    'preload("res://infrastructure',
    "res://presentation/",
    "res://scenes/",
    "res://infrastructure/",
)


def main() -> int:
    if not DOMAIN.exists():
        print("domain boundaries: domain/ does not exist yet")
        return 0

    failures: list[str] = []
    scripts = sorted(DOMAIN.rglob("*.gd"))
    for script in scripts:
        text = script.read_text(encoding="utf-8")
        relative = script.relative_to(ROOT)
        for line_number, line in enumerate(text.splitlines(), start=1):
            for token in FORBIDDEN:
                if token in line:
                    failures.append(f"{relative}:{line_number}: {token}")

    if failures:
        print("domain boundaries: FAIL")
        for failure in failures:
            print(failure)
        return 1

    print(f"domain boundaries: PASS ({len(scripts)} scripts)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
