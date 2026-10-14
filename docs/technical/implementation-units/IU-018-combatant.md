# Implementation Unit

## ID

IU-018

## Title

Combatant

## Status

DONE

## Type

DOMAIN

## Backlog Reference

BACK-031

## Risk

LOW

## Objective

Represent the player and one practice enemy as temporary combatants, without starting a fight.

## Context

PlayerState already stores hp, energy, strength, defense, speed, and luck. A combatant is a copy used only inside a battle. The design has not published final attribute tables. This prototype uses one fixed enemy.

## Dependencies

- IU-003

## Scope

- A combatant has id, side (`player` or `enemy`), hp, max_hp, energy, strength, defense, speed, and luck.
- Building one from the player copies those six numbers. max_hp is the copied hp. The player object stays unchanged.
- The practice encounter id is `practice_fight`. Its only enemy id is `practice_pirate`, side `enemy`, with hp 16, energy 10, strength 12, defense 6, speed 8, and luck 5. max_hp is 16.
- hp 0 means defeated. hp below 0 is rejected and stays unchanged.
- A new player still has the existing defaults. This unit does not open combat mode.

## Out of Scope

- Actions, turn order, hit, damage, defense, flee, and enemy choice.
- The cave roster and party members.
- Writing `GameMode` or `mission`.
- A combat screen.

## Components

### Create

- `domain/combat/combatant.gd`
- `domain/combat/practice_fight.gd`
- `tests/domain/combatant_test.gd`

### Modify

- None

## Rules

- Code identifiers stay in English.
- No `Node`, no scene path, and no `Input`.
- Do not change `PlayerState` field names or defaults.

## Architectural Constraints

- Do not rename `GameState` fields.
- The combatant is not stored on `GameState` in this unit.

## Write Scope

Allowed:

- `domain/combat/**`
- `tests/domain/combatant_test.gd`

Forbidden:

- `domain/state/**`
- `application/**`
- `presentation/**`
- `project.godot`

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/personagens.md`
- `docs/technical/implementation-units/IU-003-player-state.md`

### Relevant Specifications

- Combatant versus character
- BACK-030
- BACK-031

### Relevant Components

- `PlayerState`

### Relevant Tests

- `tests/domain/combatant_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- A combatant built from the default player has hp 10, max_hp 10, and the other four attributes at 10. The player hp stays 10.
- `practice_pirate` has the six numbers in the scope.
- hp 0 is defeated. A positive hp is not.
- Setting hp below 0 does not change the current hp.

## Tests Required

- Happy path: the player copy matches the defaults and does not write back.
- Boundary: the practice enemy matches the fixed stats, and hp 0 is defeated.
- Invalid state: hp below 0 is rejected.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

Tests can build both sides of `practice_fight`. The bar is unchanged.

## Notes

The round rules are IU-019. These enemy numbers exist so that a later hit can deal damage with the default player stats.
