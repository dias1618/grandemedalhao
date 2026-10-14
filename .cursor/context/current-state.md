# Current Project State

## Current Milestone

M04 — Combat Prototype

## Completed

- IU-001 — Initial Project Structure
- IU-002 — GameState
- IU-003 — PlayerState
- IU-004 — WorldState
- IU-005 — GameMode
- IU-006 — Scene
- IU-007 — Input
- IU-008 — Movement
- IU-009 — Collision
- IU-010 — Interaction
- IU-011 — Dialogue
- IU-012 — DialogueController
- IU-013 — Dialogue view
- IU-014 — Choice
- IU-015 — MissionState
- IU-016 — Old man choice
- IU-017 — Choice view
- IU-018 — Combatant
- IU-019 — Combat round
- IU-020 — Combat session
- IU-021 — Combat view

## In Progress

None

## Next

M05 — First Complete Route. Contratos ainda não escritos.

## Blocked

None

## Active Decisions

- ADR-001 — Godot 4.7, layer layout, and greenfield. The current prototype is not the source of truth.

## Executable Units

M01 through M04 contracts live in `docs/technical/implementation-units/`. Validate a unit with `python3 tools/harness/gate.py IU-XXX`.

## Known Technical Debt

- IU-001 and IU-002 passed their gates, but they were not reviewed by the Reviewer agent.