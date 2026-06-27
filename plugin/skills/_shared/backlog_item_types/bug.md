# Backlog item type: Bug

Templates and writing rules for `refine_backlog_item`. Output is markdown in chat (optional save under `docs/backlog/` in the target repo). No external tracker API.

---

## Required sections

| Section | Purpose |
|---------|---------|
| Error | Incorrect behavior, reproduction, and evidence |
| Expected result | Correct behavior after fix with BDD verification |
| Suggested fix steps | Practical implementation sequence |

---

## Output template

```markdown
========================================
BUG - [title or slug]
========================================

## Error

**Dependencies:** (omit if none)
- [dependency id or link]

**Incorrect behavior:**
[Precise description of what goes wrong]

**Context:**
[Where it occurs, when introduced, affected flow]

**Repositories / areas:**
- [repo or service 1]
- [repo or service 2]

**Affected files or components:**
- [path or component]

**Steps to reproduce:**
1. [Initial state]
2. [Action]
3. [Where failure appears]

**Evidence:**
[HTTP status, log excerpt, error message, observable behavior]

**Frequency and impact:**
[Always or intermittent; who or what is affected]

### Suggested fix (steps)

**Step 1 - [Action title]**
[What to do]
- File: [path]
- Depends on: [none or Step N]

**Step 2 - [Action title]**
[What to do]
- File: [path]
- Depends on: [Step 1]

---

## Expected result

**Expected behavior:**
[Positive description of correct behavior after fix]

**Verification criteria:**

Scenario 1 - [Primary fix verification]
**Given** [same conditions that reproduce the bug]
**When** [same action that triggered the error]
**Then** [correct system behavior]
**And** [no error or correct payload]

Scenario 2 - [Non-regression]
**Given** [adjacent normal usage context]
**When** [related flows run]
**Then** [existing behavior remains correct]

========================================
```

---

## Collection questions

Use when input is thin:

1. What is going wrong?
2. How do you reproduce it?
3. What should happen instead?
4. What is the impact and frequency?
5. Where should the fix happen? (optional)
6. Severity label (optional)?

---

## Writing guidelines

- Dependencies: include only when explicitly known; otherwise omit.
- Error section: describe observable behavior, not generic "does not work."
- Reproduction: specific and executable by another developer.
- Suggested fix: one responsibility per step, file hint, explicit dependencies.
- Expected result: positive behavior and at least one non-regression scenario.
- **AI stealth:** The output must read as written by a developer or QA engineer. No references to AI, generation, or automation in any field. See `GUARDRAILS.md` § 9.
