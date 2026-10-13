# Workflow — Implement Task

## Purpose

Execute one approved Implementation Unit from readiness validation through implementation, testing, validation, and handoff.

This workflow must be followed by the Implementer agent when executing a development task.

The agent must not expand the task scope, redesign the architecture, or implement future functionality unless explicitly authorized by the Implementation Unit or an approved decision.

---

# 1. Load Context

Read the minimum context necessary to execute the task correctly.

The agent must inspect, in this order:

1. Global project rules
2. `.cursor/context/project.md`
3. `.cursor/context/architecture.md`
4. `.cursor/context/current-state.md`
5. The requested Implementation Unit
6. Documents explicitly referenced by the Implementation Unit
7. Relevant source files
8. Relevant tests
9. Related ADRs when applicable

Do not read the entire repository indiscriminately.

The objective is to construct the smallest sufficient execution context.

---

# 2. Check Task Readiness

Before modifying code, verify that the Implementation Unit is ready.

Check:

- task has a clear objective;
- scope is defined;
- out-of-scope items are defined when necessary;
- dependencies are satisfied;
- acceptance criteria are testable;
- required architectural decisions exist;
- required files/components are identifiable;
- no unresolved ambiguity blocks implementation.

If an ambiguity can materially affect:

- architecture;
- public contracts;
- domain behavior;
- persistence;
- state management;
- acceptance criteria;

stop execution and report the ambiguity.

Do not silently choose an architectural direction.

---

# 3. Understand

Inspect the existing implementation before making changes.

Identify:

- existing components related to the task;
- current behavior;
- dependencies;
- extension points;
- existing tests;
- architectural constraints;
- possible regression areas.

Do not modify code during this step.

The agent must understand the existing system before proposing changes.

---

# 4. Plan

Create a concise implementation plan.

The plan must identify:

- files/components to create;
- files/components to modify;
- relevant interfaces/contracts;
- expected behavior;
- tests to create or modify;
- validation to perform.

Prefer the smallest implementation capable of satisfying the acceptance criteria.

Do not introduce speculative abstractions.

If implementation requires changing architecture or expanding scope, stop and request review before proceeding.

---

# 5. Implement

Implement only the approved scope.

During implementation:

- preserve existing behavior outside the task;
- respect architectural boundaries;
- follow project coding rules;
- prefer simple solutions;
- avoid unrelated refactoring;
- avoid speculative extensibility;
- do not modify unrelated files;
- do not weaken existing tests;
- do not remove validation merely to make tests pass.

If the implementation reveals a requirement not covered by the task, stop and report it instead of silently expanding scope.

---

# 6. Test

Create or update tests required by the Implementation Unit.

Tests should verify behavior rather than implementation details.

At minimum, consider:

- normal behavior;
- relevant boundaries;
- invalid states;
- important failure paths;
- regression risks.

Execute the relevant test suite by running `python3 tools/harness/gate.py <IU-ID>`.

If tests fail:

1. determine whether the failure is caused by the implementation;
2. determine whether it is caused by an existing problem;
3. fix implementation problems within scope;
4. do not modify tests simply to obtain a passing result.

Do not declare the task complete while required tests are failing.

---

# 7. Validate

Validate the implementation against the complete acceptance criteria.

Check:

- acceptance criteria;
- architecture;
- tests;
- build/compilation;
- static analysis when applicable;
- integration impact;
- scope compliance.

The agent must distinguish between:

- implemented;
- tested;
- validated.

Passing tests alone does not automatically mean the task satisfies the acceptance criteria.

`VALIDATED` requires both: every acceptance criterion is met, and `python3 tools/harness/gate.py <IU-ID>` exits 0.

---

# 8. Review Readiness

Before reporting completion, perform a self-review.

Ask:

- Did I implement only the requested scope?
- Did I introduce unnecessary abstractions?
- Did I violate architectural boundaries?
- Did I modify unrelated files?
- Did I preserve existing behavior?
- Did I create adequate tests?
- Did I validate the acceptance criteria?
- Did I introduce a decision that should become an ADR?
- Is there anything a Reviewer should specifically inspect?

If the task is not ready for review, report the remaining problems.

---

# 9. Report

Finish with a structured handoff.

Use the following format:

## Implementation Report

### Task

`<Implementation Unit ID>`

### Status

`IMPLEMENTED` | `TESTED` | `VALIDATED` | `BLOCKED`

### Summary

Brief description of what was implemented.

### Files Changed

List created, modified, or deleted files.

### Tests

List tests created or modified.

### Validation

List commands, checks, builds, or other validation performed and their results.

The required command is `python3 tools/harness/gate.py <IU-ID>`. A task cannot be reported as `VALIDATED` when that command exits non-zero.

### Acceptance Criteria

For each criterion:

- `[x]` satisfied
- `[ ]` not satisfied

### Decisions

List architectural or implementation decisions made during execution.

### Concerns

List risks, ambiguities, technical debt, or items requiring human attention.

### Reviewer Context

Identify the most important areas the Reviewer should inspect.

---

# Completion Rule

An Implementation Unit may only be considered ready for `DONE` when:

1. implementation is complete;
2. required tests pass;
3. acceptance criteria are satisfied;
4. architectural constraints are respected;
5. validation has been performed;
6. no unresolved blocking issue remains;
7. the implementation report has been produced.

The Implementer does not independently declare a task permanently `DONE` if the project workflow requires Reviewer approval.

The final task status must respect the project's defined workflow states.