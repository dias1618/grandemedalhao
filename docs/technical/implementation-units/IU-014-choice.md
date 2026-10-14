# Implementation Unit

## ID

IU-014

## Title

Choice

## Status

DONE

## Type

DOMAIN

## Backlog Reference

BACK-019

## Risk

LOW

## Objective

Represent the old man's yes/no question and the spoken replies as data, with no UI and no mission change.

## Context

M02 ends the five-line conversation and returns to exploration. This unit adds the question that follows those lines. Accepting or refusing does not change `mission` here.

## Dependencies

- IU-011

## Scope

- A choice has an id, a prompt, and two options. Each option has an id, a label, and the lines spoken after it.
- The choice id is `old_man_help`.
- The prompt is exactly: "Você irá atrás dos bandidos?"
- Option `accept`, label "Sim", then these lines, in order, all of type `normal`:

1. speaker `zoro`, portrait `zoro`: "Vou dar uma volta, quem sabe não encontre alguns bandidos para testar minha lâmina nova. Me aponte onde posso achar algumas cobaias, velho"
2. speaker `old_man`, portrait `old_man`: "Em uma caverna a nordeste daqui, encrustada em uma montanha, e logo após um pequeno lago... não sei como lhe pagar meu jovem..."
3. speaker `zoro`, portrait `zoro`: "Você saberá..."

- Option `refuse`, label "Não", then this single line of type `normal`:

1. speaker `zoro`, portrait `zoro`: "Quem sabe uma hora minha lâmina decida brincar com esses bandidos, por ora terá de aguardar ai, velho"

- The five lines of `old_man_conversation` stay unchanged and are not stored again in the choice.

## Out of Scope

- Drawing the options, highlighting, and keyboard or mouse selection.
- Setting `GameMode` to `choice`.
- Creating or changing `mission`.
- The cave choice, rescue, and alliance.

## Components

### Create

- `domain/choice/old_man_help_choice.gd`
- `tests/domain/choice_test.gd`

### Modify

- None

## Rules

- Spoken text stays in Portuguese, copied from the design document.
- Code identifiers stay in English.
- No `Node`, no scene path, and no `Input` in the choice data.

## Architectural Constraints

- Do not rename `GameState` fields or `GameMode` values.
- Do not edit `domain/dialogue/old_man_conversation.gd`.

## Write Scope

Allowed:

- `domain/choice/**`
- `tests/domain/choice_test.gd`

Forbidden:

- `presentation/**`
- `application/**`
- `domain/state/game_state.gd`
- `domain/dialogue/old_man_conversation.gd`

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/vertical-slice.md`
- `docs/technical/implementation-units/IU-011-dialogue.md`

### Relevant Specifications

- Initial decision, sections 9.1 and 9.2
- BACK-019
- Old man event consequences, data only

### Relevant Components

- `DialogueLine`
- `OldManConversation`

### Relevant Tests

- `tests/domain/choice_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- The choice exposes the prompt and the two labels "Sim" and "Não".
- Accept resolves to the three design lines, in that order.
- Refuse resolves to the single design line.
- An unknown option resolves to no lines.
- `mission` and `GameMode` are not written.

## Tests Required

- Happy path: accept returns the three lines and the third line has no `next`.
- Boundary: refuse returns one line and that line has no `next`.
- Invalid state: an unknown option returns no lines.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

The question and both replies can be read in tests. The bar still ends the five lines in exploration, with no question on screen.

## Notes

Selection and the mission result belong to later M03 units. Do not add the cave options here.
