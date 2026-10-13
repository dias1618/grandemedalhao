# Implementation Unit

## ID

IU-004

## Title

WorldState

## Status

DONE

## Type

DOMAIN

## Backlog Reference

BACK-005

## Risk

MEDIUM

## Objective

Store narrative world flags without tying them to UI or to a scripting engine.

## Context

Mission events will set flags later. This unit only provides a dictionary of boolean flags and wires it to `GameState.world`.

## Dependencies

- IU-002

## Scope

- Add `WorldState` with `set_flag(id, value)`, `get_flag(id)`, and `flags()` for save later.
- Unknown flags read as `false`.
- Flag ids are `StringName`. Do not hard-code the full vertical-slice flag list as required behavior.
- Set `GameState.world` to a `WorldState`.

## Out of Scope

- A generic event scripting language.
- Dialogue, mission transitions, and the concrete flags from the design docs.
- Persistence format.

## Components

### Create

- `domain/state/world_state.gd`
- `tests/domain/world_state_test.gd`

### Modify

- `domain/state/game_state.gd` so `world` is a `WorldState`

## Rules

- No node, signal to the UI, or scene path inside `WorldState`.

## Architectural Constraints

- Flag storage must stay data. Do not encode rescue versus alliance rules here.

## Write Scope

Allowed:

- `domain/state/world_state.gd`
- `domain/state/game_state.gd`
- `tests/domain/world_state_test.gd`
- `tests/domain/game_state_test.gd` only if the world slot type change requires it

Forbidden:

- `presentation/**`
- `docs/game-design/**` content implementation
- mission state machine

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`

### Relevant Specifications

- WorldState
- BACK-005

### Relevant Components

- `GameState`

### Relevant Tests

- `tests/domain/world_state_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- Flags can be set and read without any UI type.
- A missing flag reads as `false`.
- `GameState.world` holds a `WorldState`.
- Tests cover set, read, and the missing-flag default.

## Tests Required

- Happy path: set `example_flag` to true and read it back.
- Boundary: unset flag is false.
- Invalid state: empty flag id is rejected.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

World flags exist as domain data, ready for later events to write. No narrative flag is mandatory yet.

## Notes

IU-003 and IU-004 both modify `game_state.gd`. Run them sequentially, not in parallel.
