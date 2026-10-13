# Implementation Unit

## ID

IU-002

## Title

GameState

## Status

VALIDATED

## Type

DOMAIN

## Backlog Reference

BACK-003

## Risk

HIGH

## Objective

Create the session aggregate that later systems read and update.

## Context

M01 needs one object that can represent a new session before combat, missions, or save exist. Slots for those future systems stay empty.

## Dependencies

- IU-001

## Scope

- Add a `GameState` type in `domain/` with `player`, `world`, `party`, `mission`, `current_scene_id`, and `save_metadata`.
- Provide a constructor for an initial session: empty metadata, no current scene, and null optional slots.
- Keep `party` and `mission` as untyped empty slots. Do not define their rules.

## Out of Scope

- Serialization and save files.
- UI.
- Mission transitions, party membership, and scene loading.
- Strong types for `PlayerState` and `WorldState` (IU-003 and IU-004).

## Components

### Create

- `domain/state/game_state.gd`
- `tests/domain/game_state_test.gd`

### Modify

- None beyond wiring the new type if the boot scene must not construct it yet. The boot scene stays unchanged.

## Rules

- `GameState` extends `RefCounted`, not `Node`.
- No presentation references.

## Architectural Constraints

- This is a public contract. Later units may fill slots; they must not rename the fields listed in Scope.
- Changing the field list requires an ADR.

## Write Scope

Allowed:

- `domain/state/game_state.gd`
- `tests/domain/game_state_test.gd`

Forbidden:

- `presentation/**`
- `infrastructure/**`
- `project.godot`
- `docs/game-design/**`

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`

### Relevant Specifications

- GameState
- BACK-003

### Relevant Components

- None yet

### Relevant Tests

- `tests/domain/game_state_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- A new `GameState` can be created for an initial session.
- The six slots exist and the optional ones start empty.
- The type does not depend on presentation.
- Tests cover creation and the empty initial session.

## Tests Required

- `tests/domain/game_state_test.gd` happy path: initial session fields are empty.
- Boundary: `save_metadata` starts as an empty dictionary, not null.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

`GameState` exists as a domain object with stable field names and no behavior for party, mission, or save.

## Notes

High risk because `GameState` is a shared contract. Do not run this unit in parallel with another unit that edits `domain/state/game_state.gd`.
