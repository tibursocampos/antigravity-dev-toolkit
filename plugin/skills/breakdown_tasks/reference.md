# breakdown_tasks - reference

Grouping heuristics and templates for `breakdown_tasks/SKILL.md`.

---

## Parsing steps from refined markdown

| Item type | Sections to search |
|-----------|--------------------|
| User Story / Technical Story | `Steps` |
| Bug | `Suggested fix` under Error, or `Steps` |

Typical step block:

```markdown
**Step N - [Title]**
[description]
- Layer: [...]
- Depends on: [...]
```

Also accept legacy Portuguese step headings like `Etapa N` and normalize to `Step N`.

If there are only unordered bullets with no step structure, ask the user to rerun `refine_backlog_item` or confirm manual grouping.

---

## Grouping heuristics

Apply in this order:

1. Markdown sub-headings (`####`) if present.
2. Repository or service names in step text.
3. Layer-based split (backend vs frontend).
4. Fallback: single `Implementation` group if no natural split exists.

Limits:

- Maximum **5** implementation groups.
- Minimum **1** implementation group when non-test steps exist.

Test split (mandatory):

Steps with layer `Tests`, `Integration tests`, or titles containing `unit test` / `integration test` go to:

- `Tests - Backend`, and/or
- `Tests - Frontend`

Do not keep test-only steps in feature implementation groups.

---

## Output template (`docs/implementation-tasks/<slug>.md`)

```markdown
# Implementation tasks: [title]

| Field | Value |
|-------|--------|
| **Source** | docs/backlog/<slug>.md \| chat |
| **Doc language** | pt-BR \| English |
| **Repository** | [name] |
| **Progress** | 0/N groups |

## Summary

| Group | Steps | Status |
|-------|-------|--------|
| Implement [Group 1] | 1-3 | Pending |
| Implement [Group 2] | 4-5 | Pending |
| Tests - Backend | 6 | Pending |

---

## Implementation

### Group 1: [name]

**Steps covered:** 1-2

- [ ] **Step 1 - [title]**
  - Layer: [...]
  - Depends on: none
- [ ] **Step 2 - [title]**
  - Layer: [...]
  - Depends on: Step 1

### Group 2: [name]

**Steps covered:** 3-4

- [ ] **Step 3 - [title]**
  ...

---

## Tests

### Tests - Backend

**Steps covered:** 5

- [ ] **Step 5 - [title]**
  ...

### Tests - Frontend (omit if none)

- [ ] **Step N - [title]**

---

## Before PR (optional - neutral checklist)

- [ ] Build and targeted tests pass locally
- [ ] Backlog acceptance criteria re-read
- [ ] PR description lists scope and test evidence
- [ ] No secrets or local paths in diff

---

## Execution order

**Critical path:** Group 1 -> Group 2 -> ... -> Tests

**Next:** Group 1 - [name]

## SDD handoff

When scope is medium/high complexity:

`use skill sdd_spec -> use skill sdd_plan -> use skill sdd_develop`

This file is planning input and does not replace `PLAN/PLAN_*.md`.
```

---

## SDD PLAN resolution (read-only)

When handoff says PLAN already exists:

1. Read `_shared/sdd_artifacts/STORAGE.md`.
2. Resolve artifact paths for the active repository using storage rules.
3. Inspect candidate PLAN files and pick matching `PLAN_NNN_*.md`.
4. If zero or multiple matches remain, ask once in pt-BR with numbered full paths.
5. Pass full path in handoff command.

Do not use `docs/documentation-plan/plan.md` for SDD handoff.

---

## Boundary: breakdown_tasks vs sdd_plan

| Aspect | `breakdown_tasks` | `sdd_plan` |
|--------|-------------------|------------|
| Input | Refined backlog steps | PRD acceptance criteria |
| Output | `docs/implementation-tasks/<slug>.md` | Canonical `PLAN/PLAN_*.md` path |
| Granularity | Grouped checklist for one item | Baby steps across full feature scope |
| Tracker usage | Never | Never |

Use `sdd_plan` after `sdd_spec` for SDD workflow. Use `breakdown_tasks` for fast local implementation checklists.

---

## Explicit exclusions

Do **not** auto-generate:

- Mandatory AI tag tasks
- Mandatory log-link tasks
- Mandatory DeskCheck tasks
- Mandatory PR quality-tool boilerplate
- Remote board child tasks via API

If the user wants a custom workflow section, add it under **Before PR** using user wording only.
