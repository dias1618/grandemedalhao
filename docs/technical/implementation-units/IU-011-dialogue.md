# Implementation Unit

## ID

IU-011

## Title

Dialogue

## Status

DONE

## Type

DOMAIN

## Backlog Reference

BACK-016

## Risk

LOW

## Objective

Represent the old man's first conversation as data, with no UI and no choice.

## Context

M02 speaks five lines and then returns to exploration. The question "Você irá atrás dos bandidos?" belongs to M03 and must not be a line in this unit.

## Dependencies

- IU-002

## Scope

- A dialogue line has `speaker`, `text`, `type`, an optional `portrait`, and `next`.
- Types are exactly `normal`, `thought`, and `narration`.
- A `narration` line does not require a portrait. A `normal` line has a speaker.
- The dialogue id is `old_man_conversation`.
- It contains these five lines, in this order, all of type `normal`, and no sixth line:

1. speaker `old_man`, portrait `old_man`: "Sniff.... Sniff.... Não sei o que fazer agora, minha pequena foi levada por aqueles fdp."
2. speaker `zoro`, portrait `zoro`: "Não cai bem para alguém da sua idade estar chorando assim..."
3. speaker `old_man`, portrait `old_man`: "Você diz isso por que não deve ter filhos, não há tristeza maior... você parece um jovem forte, me ajude a resgata-la."
4. speaker `zoro`, portrait `zoro`: "Se é algo importante pra você não deveria deixar nas mãos de um estranho, nem que levassem seus braços e pernas você deveria toma-la de volta custe o que custar"
5. speaker `old_man`, portrait `old_man`: "Pedir ajuda a um estranho como você é a prova do meu desespero... acha que não tentei resgata-la? Acha que eu deixaria minha menina ir sem fazer nada? Tomei uma surra deles, e só estou vivo por que querem me ver humilhado... meu corpo não tem mais nenhuma força.... sozinho não consigo fazer mais nada...."

- The fifth line has no `next`. A caller can read the lines in order without a scene.

## Out of Scope

- The dialogue box, typewriter, portraits drawn on screen, and input.
- The yes/no choice and both answer lines.
- Mission flags and world flags.
- Starting or stopping `GameMode`.

## Components

### Create

- `domain/dialogue/dialogue_line.gd`
- `domain/dialogue/old_man_conversation.gd`
- `tests/domain/dialogue_test.gd`

### Modify

- None

## Rules

- Spoken text stays in Portuguese, copied from the design document.
- Code identifiers stay in English.
- No `Node`, no scene path, and no `Input` in the dialogue data.

## Architectural Constraints

- Dialogue data must not depend on presentation or on `GameState`.

## Write Scope

Allowed:

- `domain/dialogue/**`
- `tests/domain/dialogue_test.gd`

Forbidden:

- `presentation/**`
- `application/**`
- `presentation/boot.gd`
- the choice question

## References

### Required Documents

- `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`
- `docs/technical/especificacao_tecnica.md`
- `docs/technical/backlog_tecnico.md`
- `docs/game-design/eventos_dialogos_missoes.md`

### Relevant Specifications

- Dialogue
- BACK-016
- Event 01 lines before the choice

### Relevant Components

- None

### Relevant Tests

- `tests/domain/dialogue_test.gd`

### Related Decisions

- ADR-001

## Acceptance Criteria

- `old_man_conversation` has exactly five lines, in the order and wording above.
- Each of those lines names its speaker and uses type `normal`.
- The last line has no next line.
- A narration line can be represented without a portrait.
- A thought line can name `zoro` as the speaker.
- No UI type is required to read the lines.

## Tests Required

- Happy path: the first line is the old man's sniff line and the fifth line is the despair line.
- Boundary: the sequence stops after five lines.
- Invalid state: a `normal` line with an empty speaker is rejected. A `narration` line without a portrait is accepted.

## Validation

```text
python3 tools/harness/check_domain_boundaries.py
godot --headless --path . --import --quit
godot --headless --path . -s res://tests/run_domain_tests.gd
```

## Expected Result

The five lines exist as domain data. Nothing is drawn and the choice is absent.

## Notes

Low risk. Do not wire E or Space in this unit. The conversation id must stay `old_man_conversation` so IU-010 and IU-012 can share it.
