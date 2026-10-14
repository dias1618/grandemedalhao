# Implementation Unit

## ID

IU-020

## Title

Combat session

## Status

DONE

## Type

APPLICATION

## Backlog Reference

BACK-040

## Risk

MEDIUM

## Objective

Run the practice fight across rounds until victory, defeat, or flee, without the bar story.

## Context

IU-019 resolves one round when both actions and the rolls are already known. This unit owns the mode, repeats rounds, and asks the enemy for its action. It does not draw the fight.

## Dependencies

- IU-005
- IU-018
- IU-019

## Scope

- Starting the practice fight copies the player into a player-side combatant, builds `practice_pirate`, and sets the mode to `combat` by direct assignment.
- The copied player stats are the values at the start. Later changes inside the fight do not write `PlayerState`.
- The player submits one action. The enemy action is chosen by the round rule. The round then executes with the next caller-supplied roll for each action that needs one, in order.
- `attack` targets the living practice pirate. `defend` and `flee` have no target.
- While the outcome is `ongoing`, the mode stays `combat` and another action may be submitted.
- `victory`, `defeat`, or `flee` is remembered. This unit does not change `mission`, world flags, or the scene.
- An action submitted when the fight is already over does not change hp or the result.
- No story event starts this fight.

## Out of Scope

- The combat screen and the key that opens the fight.
- Applying victory or defeat to the mission.
- The cave, extra enemies, and party members.
- Replacing the bar as the opening scene.

## Components

### Create

- `application/combat/combat_session.gd`
- `tests/domain/combat_session_test.gd`

### Modify

- None

## Rules

- Rolls are passed in by the caller, in execution order. The session does not pick a random number.
- Direct assignment sets `combat`. Do not add a transition table.
- Do not copy the round formula into this unit. Call the round rule.

## Architectural Constraints

- Do not rename `GameState` fields or `GameMode` values.
- Do not edit `domain/state/player_state.gd`.

## Write Scope

Allowed:

- `application/combat/**`
- `tests/domain/combat_session_test.gd`

Forbidden:

- `presentation/**`
- `domain/combat/practice_fight.gd`
- `domain/state/game_state.gd`
- `project.godot`
- mission files

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/technical/implementation-units/IU-018-combatant.md`
- `docs/technical/implementation-units/IU-019-combat-round.md`

### Relevant Specifications

- Combat cycle
- BACK-040
- Result values victory, defeat, and flee

### Relevant Components

- `GameMode`
- `CombatRound`
- `practice_fight`
- `PlayerState`

### Relevant Tests

- `tests/domain/combat_session_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- Start sets `combat` and leaves the player's own hp at 10.
- Four hitting attacks, with the pirate not defending, reduce the pirate from 16 to 0 and return `victory`.
- A flee roll that succeeds returns `flee` while the pirate is still alive.
- After `victory`, another attack does not change the result.
- `mission` and world flags stay unchanged.

## Tests Required

- Happy path: start, then enough hitting attacks to reach `victory`, with the player hp field still 10.
- Boundary: the first action is a successful flee and the result is `flee`.
- Invalid state: submitting an action after `victory` keeps the result.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

A practice fight can finish in tests. Opening the game still shows the bar.

## Notes

The visible commands are IU-021. `presentation/boot.gd` stays out of this unit on purpose.
