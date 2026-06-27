# Backlog item type: User Story

Templates and writing rules for `refine_backlog_item`. Output is markdown in chat (optional save under `docs/backlog/` in the target repo). No external tracker API.

---

## Required sections

| Section | Purpose |
|---------|---------|
| Objective | What is delivered and business/user value |
| Context | Current flow vs expected flow |
| Repositories/areas | Affected codebases/services |
| Steps | Delivery sequence in small verifiable steps |
| Acceptance criteria (business) | User-observable behavior in BDD |
| Technical acceptance criteria | Technical checklist, not BDD |

---

## Output template

```markdown
========================================
USER STORY - [title or slug]
========================================

### Objective
[What must be delivered and what value it provides]

---

### Dependencies (omit if none)
- [dependency id or link]

### Context
[Current situation -> need -> proposed scope]

### Repositories / areas
- [repo or service 1]
- [repo or service 2]

### Current flow
[How the process works today]

### Expected flow
[How it should work after delivery]

### Steps

**Step 1 - [Action title]**
[What to do]
- Layer: [Domain / Application / Infrastructure / API / Pipeline / UI]
- Depends on: [none or Step N]

**Step 2 - [Action title]**
[What to do]
- Layer: [...]
- Depends on: [Step 1]

---

### Acceptance criteria (business)

Scenario 1 - [Main flow]
**Given** [user/system context]
**When** [action]
**Then** [business outcome]
**And** [additional condition]

Scenario 2 - [Rule or alternate flow]
**Given** [...]
**When** [...]
**Then** [...]

Scenario 3 - [Failure or exception]
**Given** [...]
**When** [...]
**Then** [...]

---

### Technical acceptance criteria

- [ ] [Verifiable technical item]
- [ ] [Verifiable technical item]
- [ ] [Verifiable technical item]

========================================
```

---

## Collection questions

Use when input is thin:

1. What must be delivered?
2. How does it work today?
3. How should it work after the change?
4. Who uses it?
5. Relevant business rules or exceptions?

---

## Writing guidelines

- Objective: beneficiary perspective and explicit value.
- Dependencies: omit when none.
- Business AC: avoid implementation jargon; use Given/When/Then/And.
- Technical AC: checklist format only; do not duplicate business AC.
- Steps: infinitive verbs, explicit dependencies, and clear layer ownership.
- **AI stealth:** The output must read as written by a developer or product owner. No references to AI, generation, or automation in any field. See `GUARDRAILS.md` § 9.
