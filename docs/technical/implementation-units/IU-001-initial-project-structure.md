# Implementation Unit

## ID

IU-001

## Title

Initial project structure

## Status

VALIDATED

## Type

FOUNDATION

## Backlog Reference

BACK-001

## Risk

HIGH

## Objective

Create the Godot 4.7 layer layout from ADR-001 and make that layout the executable project. Remove the current prototype from the execution path.

## Context

The repository already runs a village prototype. ADR-001 says that prototype is not the source of truth. This unit only creates the empty shell required by milestone M01.

## Dependencies

- ADR-001

## Scope

- Create `domain/`, `application/`, `presentation/`, `infrastructure/`, and `tests/domain/`.
- Add a main scene that starts and quits cleanly in headless mode.
- Point `project.godot` at that scene.
- Remove legacy gameplay from the execution path: menu, village, house, player controller, inventory, medallion, and `GameManager`.

## Out of Scope

- GameState, movement, dialogue, combat, save/load.
- Art, audio, and the three narrative maps.
- Migrating behavior from the legacy scripts.

## Components

### Create

- `domain/.gitkeep`
- `application/.gitkeep`
- `presentation/` boot scene
- `infrastructure/.gitkeep`
- `tests/domain/.gitkeep`

### Modify

- `project.godot` main scene and autoload list

## Rules

- Domain scripts must not depend on presentation or infrastructure.
- Do not add a test plugin.
- Do not keep the legacy scenes reachable from the main scene.

## Architectural Constraints

- Follow ADR-001.
- `project.godot` is a high-contention file. Do not change input map actions beyond what this unit needs to boot.

## Write Scope

Allowed:

- `domain/**`
- `application/**`
- `presentation/**`
- `infrastructure/**`
- `tests/**`
- `project.godot`
- legacy paths listed in Scope, only to disconnect or remove them

Forbidden:

- `docs/game-design/**`
- `docs/technical/especificacao_tecnica.md`
- inventing gameplay systems inside the boot scene

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `.cursor/rules/02-coding.mdc`

### Relevant Specifications

- Layer dependency direction
- BACK-001 acceptance criteria

### Relevant Components

- `project.godot`

### Relevant Tests

- `tests/run_domain_tests.gd`
- `tools/harness/check_domain_boundaries.py`

### Related Decisions

- ADR-001

## Acceptance Criteria

- The project imports in headless Godot.
- The main scene starts without the legacy village, inventory, or medallion flow.
- `domain/`, `application/`, `presentation/`, and `infrastructure/` exist.
- `tools/harness/check_domain_boundaries.py` exits 0.
- Domain has no dependency on presentation.

## Tests Required

- Boundary check over `domain/`.
- Headless import.
- Domain test runner, which may report zero tests.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

An empty playable-project skeleton whose main scene is the new boot scene, with the legacy prototype off the execution path.

## Notes

High risk. The Architect reviews the folder map before implementation, and a human accepts any extra deletion beyond the legacy list in Scope.
