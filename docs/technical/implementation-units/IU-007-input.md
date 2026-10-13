# Implementation Unit

## ID

IU-007

## Title

Input

## Status

DONE

## Type

APPLICATION

## Backlog Reference

BACK-012

## Risk

LOW

## Objective

Represent player actions independently from keyboard keys, and map the vertical-slice keys to those actions.

## Context

Movement and later dialogue must ask for actions such as `confirm`, not for `KEY_SPACE`. This unit does not move the character.

## Dependencies

- IU-001
- IU-005

## Scope

- Domain or application action values: `move_up`, `move_down`, `move_left`, `move_right`, `interact`, `run`, `confirm`, `back`, `pause`.
- A presentation mapper from the physical keys to those actions.
- Default map: WASD and arrows move, Shift runs, E interacts, Space confirms, Esc pauses, R goes back.
- Expose a read model of which actions are held or just pressed. Domain rules must consume that read model, not `Input`.

## Out of Scope

- Remapping UI.
- Mouse.
- Consuming the actions to move, talk, or open pause.

## Components

### Create

- `application/input/input_action.gd`
- `application/input/input_frame.gd`
- `presentation/input/keyboard_input_mapper.gd`
- `tests/domain/input_frame_test.gd`

### Modify

- `project.godot` input map entries required by the default map

## Rules

- No gameplay script branches on a keycode.
- `Input` appears only inside the presentation mapper.

## Architectural Constraints

- `input_frame.gd` must be constructable in tests without the Godot input singleton.

## Write Scope

Allowed:

- `application/input/**`
- `presentation/input/**`
- `tests/domain/input_frame_test.gd`
- `project.godot` input map only

Forbidden:

- player movement code
- dialogue
- `domain/state/**` except reads

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/interface_persistencia.md`

### Relevant Specifications

- Input actions
- BACK-012
- BACK-013

### Relevant Components

- `GameMode`

### Relevant Tests

- `tests/domain/input_frame_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- The nine actions exist.
- An `InputFrame` can be built in a test with `move_up` held and `confirm` just pressed.
- The default keyboard map covers the keys listed in Scope.
- Domain and application input types do not reference the `Input` singleton.

## Tests Required

- Happy path: a frame reports a held move action.
- Boundary: an action that was not set is not held.
- Invalid state: an unknown action cannot be inserted.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

Gameplay code can ask which action happened. Only the mapper knows the key.

## Notes

Low risk. Do not also implement IU-008 in the same change.
