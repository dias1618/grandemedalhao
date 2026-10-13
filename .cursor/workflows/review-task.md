# Workflow — Review Task

## Purpose

Review one Implementation Unit after the Implementer has produced a handoff. The Reviewer judges the diff and the contract, not the Implementer's summary alone.

## Load Context

Read, in this order:

1. `.cursor/rules/00-core.mdc`
2. `.cursor/rules/01-architecture.mdc`
3. `.cursor/rules/02-coding.mdc`
4. `.cursor/context/architecture.md`
5. The Implementation Unit
6. Documents listed under its Required Documents
7. `docs/decisions/ADR/` entries cited by the unit
8. The handoff at `.cursor/templates/handoff.md` shape, filled for this task
9. The git diff of the change

Do not load the Implementer's conversation as a substitute for the diff.

## Check

- Scope matches the unit, including Write Scope.
- Architectural boundaries match ADR-001.
- Acceptance criteria are satisfied, not merely described.
- Tests required by the unit exist and assert behavior.
- `python3 tools/harness/gate.py <IU-ID>` was run and the reported result matches a fresh run when the result is in doubt.
- No unrelated refactor, dependency, or legacy prototype extension.

A passing gate does not by itself mean APPROVED.

## Verdict

Use `.cursor/templates/review-report.md`.

- `APPROVED` when scope, architecture, correctness, and tests pass.
- `CHANGES_REQUESTED` when a bounded fix can satisfy the unit.
- `BLOCKED` when the unit or ADR must change before more code helps.

## Handoff

Leave the review report for the Integrate workflow when approved, or for the Fix workflow when changes are required.
