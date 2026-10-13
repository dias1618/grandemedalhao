# Implementation Unit

## ID

IU-013

## Title

Dialogue view

## Status

READY

## Type

PRESENTATION

## Backlog Reference

BACK-018

## Risk

MEDIUM

## Objective

Show the active dialogue line in a bottom box and let Space finish the line before advancing.

## Context

IU-012 already walks the five lines and restores exploration. This unit makes those lines visible. It is not the yes/no choice. The earlier sketch that called IU-013 "Choice" is replaced by this contract.

## Dependencies

- IU-012

## Scope

- A bottom box shows the speaker name, the line text, and a portrait stand-in.
- The portrait stand-in is a colored block: one color for `old_man`, another for `zoro`. No final character art.
- A `narration` line hides the portrait. A `thought` line is visually distinct from `normal`.
- Text is revealed progressively. The first `confirm` while the line is incomplete shows the whole line and does not advance. The next `confirm` advances. If the line is already complete, one `confirm` advances.
- When the controller finishes, the box hides and the player can walk.
- The reveal rule is testable without a scene tree. The box only draws that rule.

## Out of Scope

- The yes/no choice and its buttons.
- Final portraits, fonts beyond the engine default, and the rest of the bar layout.
- Changing the five lines or the controller's mode rules.

## Components

### Create

- `application/dialogue/line_reveal.gd`
- `presentation/dialogue/dialogue_box.gd`
- `presentation/dialogue/dialogue_box.tscn`
- `tests/domain/line_reveal_test.gd`

### Modify

- `presentation/boot.gd` only to show the box from the controller and route `confirm` through the reveal rule

## Rules

- The box reads the current line from the controller. It does not store a second script.
- Space is the `confirm` action.

## Architectural Constraints

- `line_reveal.gd` must not instance a scene or read `Input`.
- Do not change `GameMode` values.

## Write Scope

Allowed:

- `application/dialogue/line_reveal.gd`
- `presentation/dialogue/**`
- `presentation/boot.gd` only to attach the box and complete-or-advance on `confirm`
- `tests/domain/line_reveal_test.gd`

Forbidden:

- `domain/dialogue/old_man_conversation.gd`
- choice UI
- `project.godot`
- mission state

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/interface_persistencia.md`
- `docs/technical/implementation-units/IU-012-dialogue-controller.md`

### Relevant Specifications

- Dialogue box
- BACK-018
- SPACE advance rule

### Relevant Components

- `DialogueController`
- `DialogueLine`
- `InputFrame`

### Relevant Tests

- `tests/domain/line_reveal_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- During the conversation the box shows the current speaker and text.
- The first confirm on a partial line reveals the full text and stays on that line.
- A confirm on a complete line advances.
- A narration line does not show a portrait block.
- When the conversation ends, the box is hidden and movement works again.
- The five design lines are unchanged.

## Tests Required

- Happy path: confirm on an incomplete line completes it and does not request an advance.
- Boundary: confirm on a complete line requests an advance.
- Invalid state: confirm when no line is active neither completes nor advances.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

In the bar, E near the old man opens the box. Space finishes each line and then moves to the next. After the fifth line the box closes and the marker walks.

## Notes

This closes M02 together with IU-010, IU-011, and IU-012. Do not add the choice here. `presentation/boot.gd` is listed because it is the only input caller.
