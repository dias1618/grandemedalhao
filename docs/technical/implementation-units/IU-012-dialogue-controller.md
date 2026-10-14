# Implementation Unit

## ID

IU-012

## Title

DialogueController

## Status

DONE

## Type

APPLICATION

## Backlog Reference

BACK-017

## Risk

MEDIUM

## Objective

Start the old man's conversation, advance its lines, and return the session to exploration at the end.

## Context

IU-010 can name `old_man_conversation`. IU-011 stores its five lines. This unit plays that sequence and blocks movement by setting `GameMode` to `dialogue`. It does not draw the box.

## Dependencies

- IU-010
- IU-011

## Scope

- Starting `old_man_conversation` sets the session mode to `dialogue` and selects the first line.
- Advancing moves to the next line. Advancing the fifth line ends the conversation and sets the mode back to `exploration`.
- While the conversation is active, movement stays blocked because the mode is not `exploration`. Do not add another movement rule.
- Pressing interact again after the end starts the same five lines from the beginning.
- No world flag and no mission flag is written.
- `presentation/boot.gd` starts the controller when interact returns `old_man_conversation`, and advances it when `confirm` is pressed during `dialogue`.

## Out of Scope

- The dialogue box, typewriter, and portraits.
- The yes/no choice.
- A mode-transition table. The only assignments are `dialogue` at start and `exploration` at end.
- Changing movement math.

## Components

### Create

- `application/dialogue/dialogue_controller.gd`
- `tests/domain/dialogue_controller_test.gd`

### Modify

- `presentation/boot.gd` only to start and advance the controller from `interact` and `confirm`

## Rules

- The controller reads dialogue data. It does not own a second copy of the five strings.
- Gameplay code does not branch on Space or E keycodes.

## Architectural Constraints

- Do not put a `CanvasLayer` or a `Label` in the controller.
- Do not rename `GameState` fields or `GameMode` values.

## Write Scope

Allowed:

- `application/dialogue/dialogue_controller.gd`
- `presentation/boot.gd` only for interact start and confirm advance
- `tests/domain/dialogue_controller_test.gd`

Forbidden:

- `presentation/scenes/**`
- dialogue box nodes
- `domain/state/game_state.gd` field renames
- mission state

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/technical/implementation-units/IU-010-interaction.md`
- `docs/technical/implementation-units/IU-011-dialogue.md`

### Relevant Specifications

- Dialogue flow
- BACK-017
- BACK-015 mode change only

### Relevant Components

- `GameMode`
- `old_man_conversation`
- `TryInteract`

### Relevant Tests

- `tests/domain/dialogue_controller_test.gd`
- `tests/domain/move_player_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- Starting the conversation selects the first line and sets the mode to `dialogue`.
- Five advances consume the five lines. The fifth advance ends the conversation.
- The mode after the end is `exploration`.
- Starting again replays the first line.
- World flags and `mission` stay unchanged.
- No dialogue box is created.

## Tests Required

- Happy path: start, then advance to the second line while the mode stays `dialogue`.
- Boundary: advancing the last line returns the mode to `exploration`.
- Invalid state: advancing when no conversation is active does not change the mode.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

E near the old man enters dialogue and stops movement. Confirm walks the five lines and then restores exploration. The lines are still invisible.

## Notes

`presentation/boot.gd` is listed because it is the only input caller. The visible box is IU-013.
