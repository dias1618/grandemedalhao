# Workflow — Fix Task

## Purpose

Apply the required changes from a review report without reopening the Implementation Unit's scope.

## Load Context

Read:

1. The Implementation Unit
2. The review report
3. The previous handoff
4. The current diff

## Rules

Change only what the review report lists under Required Changes.

Do not add features that the reviewer did not request.

Do not weaken tests to clear a finding.

If a finding contradicts the Implementation Unit or ADR-001, stop with `BLOCKED` instead of choosing a side in code.

## Validate

Run `python3 tools/harness/gate.py <IU-ID>`.

Do not report the fix as ready for review when the gate exits non-zero.

## Report

Produce a new handoff. Set status to `TESTED` or `VALIDATED` according to the gate. Point the Reviewer at the findings that were addressed.
