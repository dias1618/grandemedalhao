# Implementation Unit

## ID

IU-021

## Title

Combat view

## Status

DONE

## Type

PRESENTATION

## Backlog Reference

BACK-041

## Risk

MEDIUM

## Objective

Show the practice fight and let the keyboard pick attack, defend, or flee.

## Context

IU-020 can finish the fight without drawing it. This unit draws that session and returns to the bar when the fight ends. It closes M04. The opening scene stays the bar.

## Dependencies

- IU-017
- IU-020

## Scope

- During exploration, the `back` action starts the practice fight. Dialogue and choice ignore that action.
- While the mode is `combat`, a box shows both combatant ids, both hp values, and the actions Attack, Defend, and Flee.
- Up and down move the highlight. The highlight starts on Attack.
- Confirm submits the highlighted action. Attack targets the practice pirate. The rolls for that round are `0` for the player's action and `0` for the enemy action, so the prototype is deterministic.
- The box then shows the outcome of that round: ongoing, victory, defeat, or flee.
- When the result is victory, defeat, or flee, the mode returns to `exploration`, the box hides, and the marker can walk. The player's persistent hp stays unchanged.
- The bar, the old man, and the yes/no choice keep their current behavior.

## Out of Scope

- Mouse, target selection among several enemies, and animation.
- A random roll.
- Writing the result into the mission.
- The cave fight and party members.
- New input actions.

## Components

### Create

- `presentation/combat/combat_box.gd`
- `presentation/combat/combat_box.tscn`

### Modify

- `presentation/boot.gd` only to start the practice fight from `back` during exploration and to route up, down, and confirm while the mode is `combat`

## Rules

- Up, down, confirm, and back are the actions already mapped. Do not add keys to `project.godot`.
- The box does not calculate hit or damage. It reads the session.
- Space remains confirm. R remains back.

## Architectural Constraints

- Do not change `GameMode` values.
- Do not put the round formula in the box script.

## Write Scope

Allowed:

- `presentation/combat/**`
- `presentation/boot.gd` only for the `back` start and the combat highlight and confirm

Forbidden:

- `domain/combat/**`
- `application/combat/**`
- `project.godot`
- `domain/state/game_state.gd`
- dialogue and choice scripts

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/interface_persistencia.md`
- `docs/technical/implementation-units/IU-020-combat-session.md`

### Relevant Specifications

- Minimal combat interface
- BACK-041
- BACK-042

### Relevant Components

- `CombatSession`
- `InputFrame`
- `GameMode`

### Relevant Tests

- `tests/domain/combat_session_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- R during exploration sets `combat` and shows the practice pirate hp at 16.
- Up and down change the highlight and do not move the marker.
- Confirm on Attack, four times, with the fixed rolls, reaches victory and returns to exploration.
- Confirm on Flee on the first turn reaches flee and returns to exploration.
- The player's persistent hp is still 10 after the fight.
- E beside the old man still opens the five lines when the mode is exploration.

## Tests Required

- No new domain rule. Highlight and the R key are presentation.
- Re-run the existing domain suite, including the IU-020 combat tests.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

In the bar, R opens the practice fight. Attack can win. Flee can leave. Afterward the marker walks and the old man still talks.

## Notes

This closes M04 together with IU-018, IU-019, and IU-020. The cave battle stays in a later milestone. `presentation/boot.gd` is listed because it is the only input caller.
