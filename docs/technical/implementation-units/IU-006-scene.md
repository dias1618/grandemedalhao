# Implementation Unit

## ID

IU-006

## Title

Scene

## Status

DONE

## Type

APPLICATION

## Backlog Reference

BACK-007

## Risk

MEDIUM

## Objective

Identify the three vertical-slice scenes and load one external exploration scene that matches `GameState.current_scene_id`.

## Context

M01 must open, start, and show an external scene. The narrative maps are not required to have final art. One placeholder scene is enough to prove loading. The other two ids must exist so later units do not rename scenes.

## Dependencies

- IU-001
- IU-002
- IU-005

## Scope

- Domain scene ids: `outside`, `bar`, `pirate_cave`.
- A use case that sets `GameState.current_scene_id` when entering a known scene and refuses an unknown id.
- Presentation loads a placeholder scene for the active id and places the view on that scene.
- Entering a scene does not modify world flags or mission data.
- Camera follows the player marker inside the loaded scene, without zoom. Base viewport stays 1280x720.

## Out of Scope

- Final map geometry, NPCs, doors with dialogue, and collision props.
- Loading `bar` and `pirate_cave` art. Their ids exist; a second placeholder packed scene is acceptable if one file can represent an empty room.
- Save/load.

## Components

### Create

- `domain/scene/scene_id.gd`
- `application/enter_scene.gd`
- `presentation/scenes/exploration_placeholder.tscn`
- `tests/domain/scene_id_test.gd`

### Modify

- Boot scene so a new session can enter `outside`
- `GameState.current_scene_id` usage only through the use case

## Rules

- Scene ids live in domain. Packed scene paths live in presentation or infrastructure.
- Entering a scene must not write world flags.

## Architectural Constraints

- Domain scene code must not call `change_scene_to_file`.

## Write Scope

Allowed:

- `domain/scene/**`
- `application/enter_scene.gd`
- `presentation/scenes/exploration_placeholder.tscn`
- `presentation/` boot scene
- `tests/domain/scene_id_test.gd`
- `project.godot` only for the main scene if the boot path must change

Forbidden:

- `docs/game-design/-mapas_cenarios.md` content implementation beyond the three ids
- dialogue and combat scenes
- legacy village scenes

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/-mapas_cenarios.md`

### Relevant Specifications

- Scene system
- BACK-007
- BACK-008
- BACK-009 camera follow only

### Relevant Components

- `GameState`
- `GameMode`

### Relevant Tests

- `tests/domain/scene_id_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- `outside`, `bar`, and `pirate_cave` are valid ids.
- An unknown id is rejected and does not change `current_scene_id`.
- Entering `outside` updates `GameState` and loads the placeholder scene.
- Entering a scene does not change world flags.
- The camera follows the player marker in the placeholder scene.

## Tests Required

- Happy path: `outside` is valid.
- Boundary: the three known ids are the full set.
- Invalid state: unknown id is rejected.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
godot --headless --path . --quit-after 1
```

## Expected Result

A session can enter `outside`, see a placeholder exploration scene, and keep mission data untouched because mission data still does not exist.

## Notes

Map layout details in the design doc are reference only. Do not build the finished bar or cave in this unit.
