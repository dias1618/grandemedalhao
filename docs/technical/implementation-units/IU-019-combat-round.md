# Implementation Unit

## ID

IU-019

## Title

Combat round

## Status

DONE

## Type

DOMAIN

## Backlog Reference

BACK-040

## Risk

MEDIUM

## Objective

Resolve one combat round from chosen actions, in a fixed order, without a screen or a story.

## Context

The design describes attack, defend, and flee, and says the final formulas are not written yet. This unit freezes a prototype formula so the implementation does not invent another one. Rolls come from the caller. There is no hidden random source.

## Dependencies

- IU-018

## Scope

- An action has an actor id, a type (`attack`, `defend`, or `flee`), and a target id. `defend` and `flee` have no target.
- Choosing an action does not change hp. Execution is a separate step after both sides have chosen.
- Order is deterministic: higher speed first, then higher hp, then side `player` before `enemy`, then id ascending.
- A roll is an integer from 0 through 99. Any other roll rejects that action and leaves both combatants unchanged.
- Hit chance is `clamp(50 + attacker.luck - target.speed, 5, 95)`. The attack hits when `roll < hit chance`.
- Damage on a hit is `max(0, attacker.strength - target.defense)`. If the target's action this round is `defend`, the damage is divided by 2 with integer division. Missed attacks deal 0. hp never falls below 0. hp 0 is defeated.
- The defensive state ends when the round ends.
- Flee chance is `clamp(40 + actor.speed - fastest living opponent speed, 5, 95)`. It succeeds when `roll < flee chance`. Success ends the round as `flee`. Failure consumes the action and the round continues.
- The practice enemy, when alive, always chooses `attack` against the first living player. It does not defend or flee.
- After execution, the outcome is `victory` when every enemy is defeated, `defeat` when every player is defeated, `flee` when a flee succeeded, otherwise `ongoing`.
- `victory` takes precedence over a later action in the same round.

## Out of Scope

- Energy cost, attack names, and more than one attack type.
- A second enemy, party members, and the cave fight.
- Setting `GameMode` or `mission`.
- The combat screen and keyboard selection.

## Components

### Create

- `domain/combat/combat_round.gd`
- `tests/domain/combat_round_test.gd`

### Modify

- None

## Rules

- The same combatants, actions, and rolls always produce the same order and the same hp.
- No `Node`, no scene path, and no `Input`.
- Do not read `PlayerState` here. Callers pass combatants.

## Architectural Constraints

- Do not rename `GameState` fields or `GameMode` values.
- Do not edit `domain/combat/practice_fight.gd` stats.

## Write Scope

Allowed:

- `domain/combat/combat_round.gd`
- `tests/domain/combat_round_test.gd`

Forbidden:

- `domain/state/**`
- `application/**`
- `presentation/**`
- `domain/combat/practice_fight.gd`
- `project.godot`

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/vertical-slice.md`
- `docs/technical/implementation-units/IU-018-combatant.md`

### Relevant Specifications

- Combat cycle
- Attack resolution
- BACK-033 through BACK-039

### Relevant Components

- `Combatant`
- `practice_fight`

### Relevant Tests

- `tests/domain/combat_round_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- With equal speed, the higher hp acts first. With equal speed and hp, the player acts before the enemy.
- An attack with roll 0 hits. An attack with roll 99 misses. hp does not go below 0.
- A defending target takes half damage, integer division, and the next round without defend uses full damage.
- A successful flee returns `flee` and does not require the enemy to be defeated. A failed flee leaves the round able to continue.
- The practice enemy's chosen action is `attack`. Selecting the player's action alone does not change hp.
- Default player versus `practice_pirate`: player damage on a hit is 4, or 2 if the pirate is defending. Pirate damage on a hit is 2.

## Tests Required

- Happy path: both choose attack, roll 0, and the faster side hits first for the damage above.
- Boundary: roll 99 misses, defend halves damage, and a flee roll of 0 returns `flee`.
- Invalid state: a roll of 100 does not change hp.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

A round can be resolved in tests. The bar still does not enter combat.

## Notes

These formulas are the M04 prototype. They are not the final combat document. The session that repeats rounds is IU-020.
