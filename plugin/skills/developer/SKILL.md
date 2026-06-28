---
name: developer
description: >
  Orchestrator skill for development tasks. Automatically routes the task to the correct specialized developer skill 
  (e.g., dotnet_developer, python_developer, react_developer, etc.) based on the repository's technology stack.
---

## STOP - Read before ANY tool call

1. Read `{pluginRoot}/GUARDRAILS.md`
2. Read `_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`
3. If the relevant gate is not approved: **STOP** - ask user **(pt-BR)** - do **NOT** Write/Shell
4. This skill body is **English**; user-facing prompts may be **(pt-BR)**

### Step -1 - Gate check (report in chat before continuing)

```
Gate check:
[ ] GUARDRAILS.md read
[ ] SESSION.md read; session-state loaded
[ ] User confirmed current action (sim)
-> If any unchecked: STOP
```

---

# Skill: developer (Orchestrator)

## Trigger

Use when user asks for `use skill developer` or requests generic coding/refactoring tasks without specifying a stack.

## Routing Logic

This skill does NOT write code directly. Its only purpose is to quickly determine the correct stack and invoke the specialized skill.

1. **Inspect the workspace**: Look for project files to identify the stack.
   - `.csproj` / `.sln` -> C# / .NET
   - `package.json` (with React) -> React
   - `package.json` (with Angular) -> Angular
   - `package.json` (Node.js/Generic) -> JavaScript/Node
   - `.py`, `requirements.txt`, `pyproject.toml` -> Python

2. **Invoke the specialized skill**:
   - Silently read the `SKILL.md` of the matched stack (e.g., `_shared/../skills/dotnet_developer/SKILL.md`).
   - Assume the identity and instructions of that skill immediately.
   - Do NOT ask the user for confirmation to switch skills.

3. **Hand over the task**: Apply the user's original request using the rules of the specialized skill.
