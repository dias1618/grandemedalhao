# Workflow — Integrate Task

## Purpose

Record an approved Implementation Unit as the new project checkpoint.

Integration is not a second implementation pass.

## Preconditions

- Review verdict is `APPROVED`.
- `python3 tools/harness/gate.py <IU-ID>` exits 0.
- No other open unit writes the same high-contention file (`project.godot`, `domain/state/game_state.gd`).

`IMPLEMENTED` is not `DONE`. This workflow is what moves an approved unit to `DONE`.

## Update the checkpoint

Edit `.cursor/context/current-state.md`:

- Move the unit id to Completed.
- Clear it from In Progress.
- Set Next to the following M01 unit, or to the next milestone when IU-009 is integrated.
- Leave Active Decisions unchanged unless the review accepted a new ADR.

Do not use `current-state.md` as a history log. Git and `docs/decisions/ADR/` keep history.

## Commit

Create a commit only when the human asked for one.

One unit should be one coherent commit. Do not mix an unrelated refactor.

## Stop

If the approved diff touches a file outside the unit's Write Scope, do not integrate. Return the unit to the Reviewer as `CHANGES_REQUESTED`.
