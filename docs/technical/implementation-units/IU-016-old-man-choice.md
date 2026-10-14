# Implementation Unit

## ID

IU-016

## Title

Old man choice

## Status

DONE

## Type

APPLICATION

## Backlog Reference

BACK-025

## Risk

MEDIUM

## Objective

After the five lines, offer the yes/no choice and apply accept or refuse to the mission.

## Context

IU-012 still ends `old_man_conversation` in `exploration`. This unit runs in that same confirm, before movement, and opens `choice` when the mission has not started. The reply lines then play through the existing controller. No choice box is drawn yet.

## Dependencies

- IU-012
- IU-014
- IU-015

## Scope

- When `old_man_conversation` ends and the mission is not started, the mode becomes `choice` in that same step. The player does not walk on that confirm.
- Choosing `accept` from `not_started` stores an `old_man_daughter` mission at `accepted`, then plays the three accept lines in `dialogue`.
- Choosing `refuse` from `not_started` leaves `mission` null and plays the one refuse line in `dialogue`.
- When those reply lines end, the mode is `exploration`.
- Ending `old_man_conversation` after the mission is already `accepted` stays in `exploration` and does not open the choice or change the stage.
- Accept from `accepted` does not change the stage. Refuse from `accepted` does not return the stage to `not_started`.
- An unknown option does not change the mode or the mission.
- Pressing E after a refusal plays the five lines and opens the choice again. Pressing E after an acceptance may replay the five lines and must not open the choice.

## Out of Scope

- The choice box, highlight, and pointer input.
- A generic event executor.
- Cave entry, rescue, alliance, and combat.
- Changing the five original lines or their order.

## Components

### Create

- `application/choice/resolve_old_man_choice.gd`
- `tests/domain/old_man_choice_test.gd`

### Modify

- `application/dialogue/dialogue_controller.gd` only to start the reply lines returned by the choice
- `presentation/boot.gd` only to offer the choice when the five lines end and to pass the selected option

## Rules

- The reply text is read from the choice data. Do not copy it into the controller.
- World flags stay unchanged.
- Direct assignment sets `choice` and `dialogue`. Do not add a transition table.

## Architectural Constraints

- Do not rename `GameState` fields or `GameMode` values.
- Do not edit `domain/dialogue/old_man_conversation.gd`.
- The controller still does not draw a box.

## Write Scope

Allowed:

- `application/choice/**`
- `application/dialogue/dialogue_controller.gd` only to start a reply sequence
- `presentation/boot.gd` only for the end-of-conversation offer and the selected option
- `tests/domain/old_man_choice_test.gd`

Forbidden:

- `presentation/dialogue/**`
- `domain/state/game_state.gd`
- `project.godot`
- choice buttons
- cave content

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/vertical-slice.md`
- `docs/technical/implementation-units/IU-014-choice.md`
- `docs/technical/implementation-units/IU-015-mission-state.md`

### Relevant Specifications

- Old man event
- Mission transitions, NOT_STARTED to ACCEPTED only
- BACK-025

### Relevant Components

- `DialogueController`
- `OldManHelpChoice`
- `MissionState`
- `GameMode`

### Relevant Tests

- `tests/domain/old_man_choice_test.gd`
- `tests/domain/dialogue_controller_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- The confirm that ends the fifth line sets `choice` when the mission is not started, and movement does not run.
- Accept sets `accepted` and selects the first accept line in `dialogue`.
- Refuse leaves `mission` null and selects the refuse line in `dialogue`.
- Finishing the reply lines returns `exploration`.
- A second accept does not change an accepted mission. A refuse does not clear it.
- The five design lines are unchanged.

## Tests Required

- Happy path: ending the conversation from `not_started` sets `choice`, and accept sets `accepted` and the first accept line.
- Boundary: refuse leaves `mission` null, and ending the reply returns `exploration`.
- Invalid state: accept when the stage is already `accepted` does not change the stage.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

E, the five lines, and the last confirm enter choice and stop the marker. The question is still invisible. Accept or refuse is only observable through tests and the mode.

## Notes

`presentation/boot.gd` is listed because it is the only input caller. The visible options are IU-017.
