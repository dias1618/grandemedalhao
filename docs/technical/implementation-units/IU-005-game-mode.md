# Implementation Unit

## ID

IU-005

## Title

GameMode

## Status

DONE

## Type

DOMAIN

## Backlog Reference

BACK-006

## Risk

MEDIUM

## Objective

Represent the operational mode of the session so later input and movement can ask whether exploration is active.

## Context

Dialogue, combat, and pause do not exist yet. The mode still has to list their values so those systems do not invent a second enum.

## Dependencies

- IU-002

## Scope

- Add a domain enum or equivalent with exactly: `main_menu`, `exploration`, `dialogue`, `choice`, `combat`, `pause`, `loading`, `saving`.
- Store the current mode on `GameState`.
- Allow a caller to read and replace the current mode.
- Initial session mode is `main_menu`.

## Out of Scope

- Blocking movement inside the player body.
- Menu UI, dialogue UI, and combat flow.
- Transition rules between modes. Any listed mode may be assigned directly in this unit.

## Components

### Create

- `domain/state/game_mode.gd`
- `tests/domain/game_mode_test.gd`

### Modify

- `domain/state/game_state.gd` to store the mode

## Rules

- Mode checks used by gameplay must call this type, not a UI screen name.

## Architectural Constraints

- Do not put input handling in the enum.

## Write Scope

Allowed:

- `domain/state/game_mode.gd`
- `domain/state/game_state.gd`
- `tests/domain/game_mode_test.gd`
- `tests/domain/game_state_test.gd` only if construction of `GameState` must set the initial mode

Forbidden:

- `presentation/**`
- input map in `project.godot`

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`

### Relevant Specifications

- GameMode
- BACK-006

### Relevant Components

- `GameState`

### Relevant Tests

- `tests/domain/game_mode_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- The eight modes exist.
- The current mode can be read and changed.
- A new session starts in `main_menu`.
- Tests cover the initial mode and a change to `exploration` and to `dialogue`.

## Tests Required

- Happy path: initial mode is `main_menu`.
- Boundary: assigning `dialogue` replaces `exploration`.
- Invalid state: an unknown mode value cannot be constructed.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

Session mode is domain data with a closed set of values and no presentation behavior.

## Notes

IU-003, IU-004, and IU-005 all touch `game_state.gd`. Keep them sequential.
