# Guide 01: Classic SDD

Use this flow for medium/high-complexity work.

## Step 1: `use skill sdd_spec`

Example:

`use skill sdd_spec — add PDF export for orders`

Expected outcome:
- canonical PRD artifact
- explicit write confirmation gate
- storage resolved from manifest v2 (`classic`)

## Step 2: `use skill sdd_plan`

Example:

`use skill sdd_plan — PRD/001_pdf_export.md`

Expected outcome:
- canonical PLAN at `PLAN/PLAN_001_pdf_export.md`
- 20-45 minute incremental execution steps
- explicit write confirmation gate

## Step 3: `use skill sdd_develop`

Example:

`use skill sdd_develop — PLAN/PLAN_001_pdf_export.md — Step 1`

Expected outcome:
- exactly one step executed
- tests run before completion
- PLAN progress updated
- stop and handoff to next session for Step 2

## Mandatory guardrails

- Read `GUARDRAILS.md` and `SESSION.md` before mutating actions.
- Do not skip `sim` confirmations.
- Do not execute Step N+1 in the same session.
- Keep chat in `pt-BR`; keep code in English.
