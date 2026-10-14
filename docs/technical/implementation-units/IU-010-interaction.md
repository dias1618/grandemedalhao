# Implementation Unit

## ID

IU-010

## Title

Interaction

## Status

DONE

## Type

APPLICATION

## Backlog Reference

BACK-014

## Risk

MEDIUM

## Objective

Let the player start the old man's conversation only by pressing interact while close to him in the bar.

## Context

M02 begins in the bar. The old man is the only interactable. Pressing E outside his range does nothing. This unit does not play dialogue lines or open a dialogue box.

## Dependencies

- IU-006
- IU-007
- IU-008
- IU-009

## Scope

- An interaction target has an id, a position, a range, and a conversation id.
- The only target is `old_man` at a fixed position in the bar. His range is 64 pixels from his position to `PlayerState.position`. His conversation id is `old_man_conversation`.
- Interact succeeds only when the mode is `exploration`, the current scene is `bar`, and the distance is within range. The result is `old_man_conversation`.
- Outside the range, in another scene, or in any other mode, interact returns no target and changes nothing.
- A new session enters `bar`. `outside` remains a valid scene id.
- The bar is its own placeholder scene: a floor, the player marker, and a visible old-man marker. No floating interaction icon.
- The bar scene keeps the node names the boot already reads for movement: `MapBounds`, `PlayerMarker`, `PlayerMarker/Body`, and `PlayerMarker/Camera2D`.

## Out of Scope

- Dialogue lines, the dialogue box, and portraits.
- Setting `GameMode` to `dialogue`. That belongs to IU-012.
- The yes/no choice, mission flags, and the cave door.
- A finished bar layout.

## Components

### Create

- `domain/interaction/interaction_target.gd`
- `application/interaction/try_interact.gd`
- `presentation/scenes/bar_placeholder.tscn`
- `tests/domain/interaction_test.gd`

### Modify

- `presentation/boot.gd` so the session enters `bar`, the bar scene loads, and E calls `try_interact`

## Rules

- No floating icon and no UI panel.
- Domain interaction code must not read `Input` or load a scene.
- E is the `interact` action, not a keycode check in gameplay code.

## Architectural Constraints

- Do not rename `GameState` fields.
- Do not change `GameMode` values.

## Write Scope

Allowed:

- `domain/interaction/**`
- `application/interaction/**`
- `presentation/scenes/bar_placeholder.tscn`
- `presentation/boot.gd` only to enter `bar`, load that scene, and record the interact result
- `tests/domain/interaction_test.gd`

Forbidden:

- `application/movement/**`
- dialogue content
- `project.godot`
- the yes/no choice

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/eventos_dialogos_missoes.md`
- `docs/game-design/interface_persistencia.md`

### Relevant Specifications

- Interaction
- BACK-014
- Event 01 trigger only

### Relevant Components

- `PlayerState`
- `GameMode`
- `InputFrame`
- `EnterScene`

### Relevant Tests

- `tests/domain/interaction_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- Within 64 pixels of `old_man`, in `bar`, during `exploration`, interact returns `old_man_conversation`.
- One pixel beyond that range returns no target and does not change mode, scene, or world flags.
- The same press in `dialogue` or in `outside` returns no target.
- A new session starts in `bar` and shows the old-man marker.
- No dialogue line is stored or displayed.

## Tests Required

- Happy path: in range during exploration in the bar returns `old_man_conversation`.
- Boundary: distance 64 succeeds and distance 65 fails.
- Invalid state: interact during `dialogue` returns no target.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

The player can walk in the bar, stand next to the old man, press E, and get the conversation id. Nothing is said yet.

## Notes

Do not implement IU-011 in this change. `presentation/boot.gd` is listed because it is the only input caller.
