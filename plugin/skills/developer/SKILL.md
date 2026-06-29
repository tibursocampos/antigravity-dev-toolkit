---
name: developer
description: >
  Generic development skill. Acts as a smart router for heavy frameworks (delegating to specialized skills) OR 
  acts directly as a Senior Fullstack/DevOps engineer for ad-hoc scripts, HTML, and automation tasks.
---

## STOP - Read before ANY tool call

1. Read `{pluginRoot}/GUARDRAILS.md`
2. Read `_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`
3. If the relevant gate is not approved: **STOP** - ask user **(pt-BR)** - do **NOT** Write/Shell
4. SDD/develop skills: after **ONE** step/task, **STOP** session - handoff only
5. This skill body is **English**; user-facing prompts may be **(pt-BR)**

### Step -1 - Gate check (report in chat before continuing)

```
Gate check:
[ ] GUARDRAILS.md read
[ ] SESSION.md read; session-state loaded
[ ] User confirmed current action (sim)
-> If any unchecked: STOP
```

---

# Skill: developer (Hybrid Router & Implementer)

## Trigger

Use when user asks for `use skill developer` or requests generic coding/refactoring tasks without specifying a stack.

## Routing Logic

1. **Inspect the workspace**: Look for project files to identify the stack.
   - `.csproj` / `.sln` -> C# / .NET
   - `package.json` (with React) -> React
   - `package.json` (with Angular) -> Angular
   - `package.json` (Node.js/Generic) -> JavaScript/Node
   - `.py`, `requirements.txt`, `pyproject.toml` -> Python

2. **Invoke the specialized skill (If Match Found)**:
   - Silently read the `SKILL.md` of the matched stack (e.g., `_shared/../skills/dotnet_developer/SKILL.md`).
   - Assume the identity and instructions of that skill immediately.
   - Do NOT ask the user for confirmation to switch skills.

3. **Fallback Mode (If No Match Found)**:
   - If no major framework structure is detected (e.g., isolated `.html`, `.sh`, `.bat`, `.ps1` files), **DO NOT delegate**.
   - Assume the task directly using standard, secure engineering practices as a Senior Developer.
   - Proceed to the Execution Process below.

## Execution Process (Only for Fallback Mode)

### 0. Workspace
Confirm target repo, read `README.md` (if exists), and summarize requested acceptance.

### 1. Micro-plan
Define 2-5 concrete tasks. Checkpoint context usage after each major change.

### 2. Implement
Write clean, maintainable code following universal best practices for the target language (e.g., HTML, Bash, Python script).

### 3. Tests / Validation
Run local scripts or linting tools to ensure the code executes without syntax errors.

### 4. Handoff
Offer `use skill commit`. Do not commit automatically.

## Must not
- Auto-commit or auto-PR
- Leave AI traces in code comments or identifiers
