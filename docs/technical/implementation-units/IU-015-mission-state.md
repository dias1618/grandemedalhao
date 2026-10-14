# Implementation Unit

## ID

IU-015

## Title

MissionState

## Status

DONE

## Type

DOMAIN

## Backlog Reference

BACK-024

## Risk

LOW

## Objective

Represent the mission as not started or accepted, without a route and without applying the old man's choice.

## Context

`GameState.mission` is null. Null means the mission has not started. This unit adds a state object that later units can store in that same field.

## Dependencies

- IU-002

## Scope

- A mission state has the id `old_man_daughter` and a stage.
- The only stages are `not_started` and `accepted`.
- A new mission state starts at `not_started`.
- Reading a null `GameState.mission` means `not_started`.
- The field name `mission` stays. `GameState._init` keeps `mission` null.

## Out of Scope

- Accept and refuse transitions.
- Stages past `accepted`, including the cave.
- Routes `rescue` and `alliance`.
- Completed-event lists, save, and load.
- Changing mode or dialogue.

## Components

### Create

- `domain/mission/mission_state.gd`
- `tests/domain/mission_state_test.gd`

### Modify

- None

## Rules

- Code identifiers stay in English.
- No `Node`, no scene path, and no `Input`.

## Architectural Constraints

- Do not rename `GameState` fields.
- Do not assign `mission` inside `GameState._init`.

## Write Scope

Allowed:

- `domain/mission/**`
- `tests/domain/mission_state_test.gd`

Forbidden:

- `domain/state/game_state.gd`
- `application/**`
- `presentation/**`
- choice UI

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/eventos_dialogos_missoes.md`
- `docs/technical/implementation-units/IU-002-game-state.md`

### Relevant Specifications

- Mission state
- BACK-024
- NOT_STARTED and ACCEPTED only

### Relevant Components

- `GameState`

### Relevant Tests

- `tests/domain/mission_state_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- A new mission state is `old_man_daughter` at `not_started`.
- Null `mission` is read as `not_started`.
- An existing session still leaves `mission` null until a later unit assigns it.
- No route value exists.

## Tests Required

- Happy path: a new mission state reports `not_started`.
- Boundary: null `mission` reports `not_started`.
- Invalid state: a stage outside `not_started` and `accepted` is rejected.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

Tests can tell a missing mission from an accepted one. Gameplay is unchanged.

## Notes

The accept transition is IU-016. Do not start the mission in this unit.
