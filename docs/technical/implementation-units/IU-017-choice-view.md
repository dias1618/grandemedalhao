# Implementation Unit

## ID

IU-017

## Title

Choice view

## Status

DONE

## Type

PRESENTATION

## Backlog Reference

BACK-021

## Risk

MEDIUM

## Objective

Show the yes/no question and let the keyboard pick Sim or Não before the reply lines play.

## Context

IU-016 already opens `choice` and applies the mission result. This unit draws that choice and routes the existing move and confirm actions through it. It closes M03.

## Dependencies

- IU-013
- IU-016

## Scope

- While the mode is `choice`, a box shows the prompt and the two labels from the choice data.
- Up and down move the highlight. The highlight starts on "Sim".
- Confirm on the highlighted option applies that option and then shows the reply lines in the existing dialogue box.
- The dialogue box hides while the choice is open, and the choice box hides when the reply lines start.
- When the reply ends, both boxes are hidden and the marker can walk.
- The labels and the prompt are read from the choice. They are not copied into the scene.

## Out of Scope

- Mouse selection.
- A continue indicator, final art, and a second theme.
- The cave choice and any mission stage beyond `accepted`.
- Changing the choice text, the reply lines, or the accept and refuse rules.

## Components

### Create

- `presentation/choice/choice_box.gd`
- `presentation/choice/choice_box.tscn`

### Modify

- `presentation/boot.gd` only to show the choice, move the highlight, and confirm the highlighted option

## Rules

- Up, down, and confirm are the actions already mapped for movement and dialogue. Do not add keys to `project.godot`.
- Space remains the confirm action.
- The box does not decide the mission result.

## Architectural Constraints

- Do not change `GameMode` values.
- Do not put the accept transition in the box script.

## Write Scope

Allowed:

- `presentation/choice/**`
- `presentation/boot.gd` only to attach the choice box and route up, down, and confirm while the mode is `choice`

Forbidden:

- `domain/choice/**`
- `application/choice/**`
- `project.godot`
- `domain/state/game_state.gd`
- cave content

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/interface_persistencia.md`
- `docs/technical/implementation-units/IU-016-old-man-choice.md`

### Relevant Specifications

- Choice interface
- BACK-021
- Keyboard selection only

### Relevant Components

- `DialogueBox`
- `ResolveOldManChoice`
- `InputFrame`

### Relevant Tests

- `tests/domain/old_man_choice_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- The choice box shows "Você irá atrás dos bandidos?", "Sim", and "Não".
- Up and down change the highlight and do not move the marker.
- Confirm on "Sim" accepts the mission and shows the first accept line.
- Confirm on "Não" leaves the mission unstarted and shows the refuse line.
- After the reply, the boxes are hidden and walking works.
- The choice text in the domain data is unchanged.

## Tests Required

- No new domain rule. The selection highlight is presentation.
- Re-run the existing domain suite, including the IU-016 choice tests, to show the mission rules still hold.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

In the bar, E and Space through the five lines open the question. Sim starts the mission and speaks the three replies. Não speaks the refusal and leaves the mission unstarted. Walking resumes after the reply.

## Notes

This closes M03 together with IU-014, IU-015, and IU-016. Mouse and the cave choice stay out. `presentation/boot.gd` is listed because it is the only input caller.
