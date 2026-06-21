# refine_backlog_item - reference

Scorecard, guardrails, and boundaries for `refine_backlog_item/SKILL.md`.

---

## Boundary: refine_backlog_item vs sdd_spec

| Aspect | `refine_backlog_item` | `sdd_spec` |
|--------|------------------------|------------|
| Purpose | Fast intake and clarification for one backlog item | Full PRD for medium/high complexity features |
| Output | Structured markdown + scorecard in chat | PRD with SDD storage and traceability |
| Persistence | Optional `docs/backlog/<slug>.md` | Canonical SDD artifact path from `_shared/sdd_artifacts/STORAGE.md` |
| Acceptance | BDD in item template + scorecard rubric | PRD acceptance criteria + handoff to `sdd_plan` |
| Escalation trigger | Scope spans multiple areas, migrations, or unclear boundaries | Run `sdd_spec`; do not expand refine output into a PRD inline |

`sdd_spec` does **not** replace refine for one-line ideas. Refine first, then escalate when needed.

Suggested escalation wording:

```
This item is large enough for SDD. Next: use skill sdd_spec, then use skill sdd_plan.
```

Before suggesting `sdd_spec`, optionally inspect existing SDD artifacts using `_shared/sdd_artifacts/STORAGE.md` resolution rules to avoid duplicate scope.

---

## Scorecard rubric

Score immediately after generating markdown. Maximum **100** points.

### Universal criteria (all item types)

| Criterion | Max | Scoring guide |
|-----------|-----|----------------|
| Objective | 15 | 15: specific and concise / 8: mostly correct but generic / 3: vague / 0: missing |
| Acceptance criteria (BDD) | 25 | 25: complete happy path + error + edge / 15: partial / 8: weak format / 0: missing |
| Implementation steps | 20 | 20: granular, ordered, explicit deps / 12: mostly good / 5: generic / 0: missing |
| No vague language | 10 | 10: none / 5: 1-2 vague phrases / 0: multiple vague statements |

### Type-specific criteria (30 points total)

**Technical Story**

| Criterion | Max |
|-----------|-----|
| Technical context (problem, solution, scope) | 10 |
| Repositories/areas listed | 5 |
| Technical specificity | 10 |
| Dependencies declared or omitted correctly | 5 |

**User Story**

| Criterion | Max |
|-----------|-----|
| Context + current vs expected flow | 10 |
| Repositories/areas listed | 5 |
| Business AC and technical AC separated | 10 |
| Dependencies declared or omitted correctly | 5 |

**Bug**

| Criterion | Max |
|-----------|-----|
| Repro steps + evidence | 10 |
| Frequency and impact | 5 |
| Suggested fix steps with files and deps | 10 |
| Non-regression BDD scenario | 5 |

### Scorecard output format

```markdown
---

## Quality scorecard

| Criterion | Score | Max | Note |
|-----------|-------|-----|------|
| Objective | [x] | 15 | [specific note] |
| Acceptance criteria (BDD) | [x] | 25 | [specific note] |
| Implementation steps | [x] | 20 | [specific note] |
| No vague language | [x] | 10 | [specific note] |
| [type-specific 1] | [x] | [max] | [specific note] |
| [type-specific 2] | [x] | [max] | [specific note] |
| [type-specific 3] | [x] | [max] | [specific note] |
| [type-specific 4] | [x] | [max] | [specific note] |

### Total: [sum] / 100

### Strengths
- [specific]

### Improvements
- **[Criterion]**: [what is missing and how to fix]

---
```

Rules: notes must be concrete, and improvements must identify precise gaps.

---

## Guardrails (before final output)

- [ ] No empty or placeholder sections
- [ ] No vague phrases like "works correctly", "as expected", "properly"
- [ ] BDD uses **Given / When / Then / And**
- [ ] No unit-test-only scenarios in acceptance criteria
- [ ] No environment-variable checks as acceptance criteria
- [ ] Heading structure matches the selected type template

**Technical Story / User Story**

- [ ] Steps ordered by layer when applicable
- [ ] Dependencies section omitted if none

**User Story**

- [ ] Business AC avoids implementation jargon
- [ ] Technical AC uses checklist format, not BDD

**Bug**

- [ ] Reproduction steps are actionable
- [ ] Expected result describes positive behavior

If guardrails fail, request missing details before publishing.

---

## Optional save: `docs/backlog/<slug>.md`

Prefix saved file with metadata:

```markdown
# Backlog: [title]

| Field | Value |
|-------|--------|
| **Type** | Bug \| User Story \| Technical Story |
| **Doc language** | pt-BR \| English |
| **Refined** | YYYY-MM-DD |
| **Repository** | [folder or remote name] |

[generated body]
```

---

## Relationship to breakdown_tasks

| Skill | Use |
|-------|-----|
| `refine_backlog_item` | Produces steps under `Steps` (or Bug `Suggested fix`) |
| `breakdown_tasks` | Groups those steps into an implementation checklist file |

After refine, offer:

```
use skill breakdown_tasks
```
