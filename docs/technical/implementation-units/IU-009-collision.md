# Implementation Unit

## ID

IU-009

## Title

Collision

## Status

DONE

## Type

PRESENTATION

## Backlog Reference

BACK-011

## Risk

MEDIUM

## Objective

Stop the protagonist on solid bounds and structural obstacles, and commit only the unblocked position back to `PlayerState`.

## Context

IU-008 already computes a desired position in open space. This unit is the milestone M01 check that Zoro cannot walk through the placeholder scenery or leave the playable area.

## Dependencies

- IU-008

## Scope

- Placeholder solids: map bounds, one wall, and one structural prop in the exploration scene.
- A movement adapter that asks whether the desired position is blocked and, if it is, keeps the last unblocked position in `PlayerState`.
- Domain-level predicate tests with axis-aligned rectangles. No scene tree in those tests.
- The body must not pass through those solids and must not stick forever against them when the player releases the direction.

## Out of Scope

- Destructible trees and rocks, water, swimming, and advanced physics.
- Collision for NPCs.
- Final art for the bar and the cave.

## Components

### Create

- `domain/movement/blocked_movement.gd`
- `tests/domain/blocked_movement_test.gd`
- Collision shapes on the placeholder exploration scene

### Modify

- `application/movement/move_player.gd` only to accept a blocker result without embedding scene nodes

## Rules

- Solid rectangles used by the rule are data, not `StaticBody2D` nodes, inside the domain test.
- Presentation translates scene bodies into that data before calling the rule.

## Architectural Constraints

- `blocked_movement.gd` must not reference physics nodes.

## Write Scope

Allowed:

- `domain/movement/blocked_movement.gd`
- `application/movement/move_player.gd`
- `presentation/scenes/exploration_placeholder.tscn`
- `tests/domain/blocked_movement_test.gd`
- `tests/domain/move_player_test.gd` if the movement signature gains a blocker argument

Forbidden:

- NPC interaction
- legacy village collision
- changing `GameMode` values

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/technical/implementation-units/IU-008-movement.md`

### Relevant Specifications

- Collision
- BACK-011
- BACK-010 collision clause

### Relevant Components

- `MovePlayer`
- `PlayerState`

### Relevant Tests

- `tests/domain/blocked_movement_test.gd`
- `tests/domain/move_player_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- A desired position inside a solid rectangle is rejected.
- A desired position in open space is accepted.
- Map bounds reject a position outside the playable rectangle.
- Releasing input after contact does not keep applying a slide.
- The placeholder scene contains the bounds, one wall, and one prop, and the visible marker cannot cross them.
- `PlayerState.position` stays on the last accepted position.

## Tests Required

- Happy path: open-space destination is accepted.
- Boundary: destination exactly on the far edge of the playable rectangle is accepted; one unit past it is rejected.
- Invalid state: overlapping a solid is rejected.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

Milestone M01 movement is blocked by placeholder scenery, and the domain position matches the last legal step.

## Notes

This closes M01 together with IU-001 through IU-008. Do not start dialogue in this unit.
