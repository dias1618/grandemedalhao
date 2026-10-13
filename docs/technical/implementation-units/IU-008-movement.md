# Implementation Unit

## ID

IU-008

## Title

Movement

## Status

DONE

## Type

APPLICATION

## Backlog Reference

BACK-010

## Risk

MEDIUM

## Objective

Move Zoro from input actions and write the resulting position and direction into `PlayerState`.

## Context

M01 requires the protagonist to move. Collision blocking is IU-009. This unit moves in open space and already refuses movement when the mode is not `exploration`.

## Dependencies

- IU-003
- IU-005
- IU-006
- IU-007

## Scope

- A pure movement step that takes `PlayerState`, `GameMode`, an `InputFrame`, and a delta, and returns the next position and direction.
- Walk speed and run speed are constants on the use case. Run applies when `run` is held together with a move action.
- Presentation applies that step to the player marker while the mode is `exploration`.
- `dialogue`, `choice`, `combat`, and `pause` leave the position unchanged.
- Diagonal input is allowed and should be normalized so it is not faster than orthogonal movement.

## Out of Scope

- Collision, map bounds, and physics bodies.
- Animation beyond a direction change on the state.
- Pathfinding.

## Components

### Create

- `application/movement/move_player.gd`
- `tests/domain/move_player_test.gd`

### Modify

- Presentation player marker created for the placeholder scene, only to display the domain position

## Rules

- The source of truth after a step is `PlayerState.position`, not the body transform alone.
- Tests must not instance a scene.

## Architectural Constraints

- The movement function must not call `Input` or `move_and_slide`.

## Write Scope

Allowed:

- `application/movement/**`
- `presentation/` player marker in the placeholder scene
- `tests/domain/move_player_test.gd`

Forbidden:

- collision shapes as the movement rule
- `domain/state/game_state.gd` field renames
- dialogue blocking beyond the mode check

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/technical/implementation-units/IU-007-input.md`

### Relevant Specifications

- Movement
- BACK-010 except collision, which is IU-009

### Relevant Components

- `PlayerState`
- `GameMode`
- `InputFrame`

### Relevant Tests

- `tests/domain/move_player_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- A move action changes `PlayerState.position` and `direction`.
- Holding run increases the distance compared with walking for the same delta.
- In `dialogue` and `combat`, the same input leaves the position unchanged.
- Diagonal movement is not faster than orthogonal movement.
- Presentation shows the marker at the domain position during `exploration`.

## Tests Required

- Happy path: `move_right` while exploring changes position and sets direction `right`.
- Boundary: zero delta does not move.
- Invalid state for this unit: mode `dialogue` ignores move actions.
- Run covers more distance than walk.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

Zoro walks and runs in the placeholder scene while exploring, and stands still in non-exploration modes. Obstacles are not solid yet.

## Notes

Do not satisfy the backlog line "respeita colisões" here. That criterion belongs to IU-009.
