# Backlog item type: Technical Story

Templates and writing rules for `refine_backlog_item`. Output is markdown in chat (optional save under `docs/backlog/` in the target repo). No external tracker API.

---

## Required sections

| Section | Purpose |
|---------|---------|
| Objective | What will be built and technical value |
| Context | Problem, scope, and motivation |
| Repositories/areas | Affected codebases/services |
| Steps | Technical delivery sequence by layer |
| Acceptance criteria | Verifiable technical BDD scenarios |

---

## Output template

```markdown
========================================
TECHNICAL STORY - [title or slug]
========================================

### Objective
[What will be built and the technical value]

---

### Dependencies (omit if none)
- [dependency id or link]

### Context
[Current state -> problem -> proposed solution and scope]

### Repositories / areas
- [repo or service 1]
- [repo or service 2]

---

### Steps

**Step 1 - [Action title]**
[What to do]
- Layer: [Domain / Application / Infrastructure / API / Tests]
- Depends on: [none or Step N]

**Step 2 - [Action title]**
[What to do]
- Layer: [...]
- Depends on: [Step 1]

---

### Acceptance criteria

Scenario 1 - [Happy path]
**Given** [technical initial context]
**When** [action]
**Then** [observable result]
**And** [extra condition if needed]

Scenario 2 - [Validation or invalid input]
**Given** [invalid or incomplete data]
**When** [action]
**Then** [descriptive error and no side effects]

Scenario 3 - [Error or edge case]
**Given** [failure context]
**When** [action]
**Then** [correct handling]

========================================
```

---

## Collection questions

Use when input is thin:

1. What needs to be built?
2. Why is this change needed?
3. Which components or layers are affected?
4. Constraints or risks?
5. Additional context?

---

## Writing guidelines

- Objective: concise and affirmative.
- Dependencies: omit when none.
- Steps: one responsibility per step, explicit dependencies, and layer progression.
- Acceptance criteria: verifiable facts using Given/When/Then/And.
- Do not use unit-test scenarios as acceptance criteria.
- **AI stealth:** The output must read as written by a developer or tech lead. No references to AI, generation, or automation in any field. See `GUARDRAILS.md` § 9.
