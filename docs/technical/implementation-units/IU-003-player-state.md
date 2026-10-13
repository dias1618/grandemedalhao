# Implementation Unit

## ID

IU-003

## Title

PlayerState

## Status

DONE

## Type

DOMAIN

## Backlog Reference

BACK-004

## Risk

MEDIUM

## Objective

Represent the persistent state of the protagonist, including position, scene, facing, and combat attributes.

## Context

Movement and later combat read this object. The protagonist id for the vertical slice is `zoro`. Stats exist so combat can consume them later; this unit does not resolve combat.

## Dependencies

- IU-002

## Scope

- Add `PlayerState` with `character_id`, `position`, `scene_id`, `direction`, and attributes `hp`, `energy`, `strength`, `defense`, `speed`, `luck`.
- Store `position` as `Vector2`.
- Direction values: `up`, `down`, `left`, `right`.
- Assign the player slot on `GameState` to a `PlayerState`.
- Initial attributes are positive numbers sufficient for a later combat prototype. Document the chosen defaults next to the type. Do not tune a full character sheet.

## Out of Scope

- Sprite, animation, inventory, equipment.
- Damage, healing, and death.
- Reading keyboard input.

## Components

### Create

- `domain/state/player_state.gd`
- `tests/domain/player_state_test.gd`

### Modify

- `domain/state/game_state.gd` so `player` is a `PlayerState`

## Rules

- Position changes are explicit methods or field writes on the domain object, not on a `CharacterBody2D`.
- `character_id` for the initial protagonist is `zoro`.

## Architectural Constraints

- Do not move `GameState` into presentation to attach the player body.

## Write Scope

Allowed:

- `domain/state/player_state.gd`
- `domain/state/game_state.gd`
- `tests/domain/player_state_test.gd`
- `tests/domain/game_state_test.gd` only if the player slot type change requires it

Forbidden:

- `presentation/**`
- `infrastructure/**`
- combat resolution
- `project.godot`

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/personagens.md`

### Relevant Specifications

- PlayerState
- BACK-004

### Relevant Components

- `GameState`

### Relevant Tests

- `tests/domain/player_state_test.gd`
- `tests/domain/game_state_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- `PlayerState` stores position, scene id, direction, character id, and the six attributes.
- Position and scene id can be changed.
- `GameState.player` holds a `PlayerState`.
- Tests cover stored fields, position update, and scene id update.

## Tests Required

- Happy path: create Zoro and read the attributes back.
- Boundary: position update replaces the previous `Vector2`.
- Invalid state: empty `character_id` is rejected.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

The session can name the protagonist, place him in a scene, and expose attributes without a sprite or combat rules.

## Notes

Read only the protagonist section of `personagens.md`. Ignore Haki, inventory, and abilities listed as out of scope for the vertical slice.
