---
name: refactor
description: >
  Analyze code files for complexity, code smells, or technical debt, draft a safe refactoring plan,
  and execute it step-by-step, validating with test runs at each step. Use when the user says
  "use skill refactor", "refactor code", or "/refactor".
---

## STOP - Read before ANY tool call

1. Read `{pluginRoot}/GUARDRAILS.md`
2. Read `_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`
3. If the relevant gate is not approved: **STOP** - ask user **(pt-BR)** â€” do **NOT** Write/Shell
4. SDD/develop skills: after **ONE** step/task, **STOP** session - handoff only
5. This skill body is **English**; user-facing prompts may be **(pt-BR)**

### Step -1 - Gate check (report in chat before continuing)

```
Gate check:
[ ] GUARDRAILS.md read
[ ] SESSION.md read; session-state loaded
[ ] PIPELINE.md read (SDD/speckit skills only)
[ ] User confirmed current action (sim)
â†’ If any unchecked: STOP
```

---

# Skill: refactor

## Trigger

Invoke when the user requests: `use skill refactor`, `refactor code`, `/refactor`, or when code reviews indicate high complexity.

**Arguments (optional):**

| Input | Meaning |
|-------|---------|
| File path | Target file to analyze and refactor |
| Method name | Target specific routine or component within a file |

## Outcome

Safely refactored code with lower cognitive complexity, improved testability, and adherence to language-specific clean code guidelines, without breaking existing test suites.

## Lazy-load

| When | Path |
|------|------|
| C# projects | `_shared/dotnet_guidelines/csharp-patterns.md`, `_shared/dotnet_guidelines/csharp-formatting.md` |
| Python projects | `_shared/python_guidelines/principles.md`, `_shared/python_guidelines/google-style.md` |
| JavaScript / TypeScript | `_shared/javascript_guidelines/clean-code-js.md`, `_shared/javascript_guidelines/clean-code-ts.md`, `_shared/javascript_guidelines/google-ts-style.md` |
| React components | `_shared/react_guidelines/clean-react.md`, `_shared/react_guidelines/philosophies.md` |
| Angular directives / templates | `_shared/angular_guidelines/angular-skills.md`, `_shared/angular_guidelines/styleguide.md`, `_shared/angular_guidelines/best-practices.md` |
| Caveman Mode (if active) | `_shared/caveman/CAVEMAN.md` Ã¢â‚¬â€ Full mode |

## Process

### -1. Re-check guardrails and session
Confirm `GUARDRAILS.md` and `SESSION.md` are loaded before continuing.
If missing, ask user (pt-BR):

```text
Antes do refactor, confirme:
- GUARDRAILS.md lido
- SESSION.md carregado

Posso seguir? (sim / ajustar / cancelar)
```

### -2. Caveman Mode Check
Check `~/.gemini/antigravity-ide/sdd/preferences.json`.
If `caveman_mode: true`, load `_shared/caveman/CAVEMAN.md` rules and keep replies compressed.

### 0. Detect Tech Stack and Load Guidelines
* Check the current workspace files (look for `.csproj`, `package.json`, `requirements.txt`, etc.).
* Lazy-load the corresponding language guidelines from the `_shared/` directory.

### 1. Code Smells Analysis
* Read the target file. Identify code smells:
  * Methods or functions exceeding 30 lines.
  * Deep nesting (more than 3 levels of indentation).
  * Magic strings or hardcoded parameters.
  * Duplicate blocks of code within the file.
  * Violation of SOLID principles (e.g., class doing too many things).
* Present a summary of identified smells.

### 2. Workflow Decision & Path Selection
* Present the summary of identified code smells and debt.
* Stop and ask the user to choose the workflow execution path based on the scope:
  * **Option A - Direct Developer Skill (`use skill developer`):** For straightforward local refactoring edits.
  * **Option B - Classic SDD (`use skill sdd_spec` -> `sdd_plan` -> `sdd_develop`):** For complex structural refactorings requiring a formal specification (PRD) and a step-by-step checklist (PLAN) in Portuguese.
  * **Option C - Spec Kit (`use skill speckit_spec` -> `speckit_plan` -> `speckit_develop`):** For repositories initialized with Spec Kit.
  * **Option D - Plain Chat Plan:** Establish a simple task list directly in the chat, executing steps one by one without extra file creations.
* **Wait for explicit user choice** before writing code or initializing another workflow.

### 3. Step-by-Step Execution & Validation
* For each accepted refactoring step:
  * Apply the minimum diff modification.
  * Run compiler checks (e.g. `dotnet build`, `npm run build`, `mypy` or build/typecheck commands).
  * Run the unit test suite (e.g. `dotnet test`, `npm test`, `pytest`).
  * If validation fails:
    * Revert the current step immediately.
    * Explain the failure and discuss alternative approaches.
  * If validation passes, proceed to the next step.

### 4. Code Formatting
* Once all steps are complete, run the target formatter on the refactored files (e.g. CSharpier, Prettier, Black, Ruff) to align with style rules.

### 5. Handoff
* Ask the user if they want to review the final diff and handoff to the commit skill:
  ```
  use skill commit
  ```

## Must not
* Perform functional changes (adding features, fixing bugs) at the same time as refactoring.
* Commit or push changes automatically without explicit user confirmation.
