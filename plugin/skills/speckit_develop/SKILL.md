---
name: speckit-develop
description: >
  Implement one task from the Spec Kit tasks.md checklist.
  Use when asked to develop speckit work, execute a speckit task, or /speckit_develop.
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
[ ] PIPELINE.md read (SDD/speckit skills only)
[ ] User confirmed current action (sim)
- If any unchecked: STOP
```

---

# Skill: speckit_develop

## Trigger

Invoke when the user asks for: `use skill speckit_develop`, `execute speckit task`, `develop spec kit`, or `/speckit_develop`.

## Outcome

Production code and/or tests written (in **English**) for one pending task from `tasks.md`. The `tasks.md` file is updated with that task marked complete (`- [x]`).

## Lazy-load (only when needed)

| When | Path |
|------|------|
| Storage schema v2 and manifest | `_shared/sdd_artifacts/STORAGE.md` § Global Manifest and Dynamic Storage Resolution |
| Project architecture rules | `.specify/memory/constitution.md` (resolved destination) |
| .NET / C# rules | `_shared/dotnet_guidelines/clean-architecture.md`, `csharp-patterns.md` |
| General code guidelines | `_shared/code_guidelines/*.md` (by detected stack) |
| Caveman Mode (if active) | `_shared/caveman/CAVEMAN.md` - Full mode |

## Process

### -1. Validate speckit initialization

Run `scripts/validate-speckit-init.ps1` before any implementation workflow action.
- If validation fails: **STOP** and handoff to `use skill speckit_init`.
- If validation passes: continue.

### 0. Load context

Load `STORAGE.md` and run the dynamic storage resolution algorithm using schema v2 with parameter `$Workflow = speckit`. Resolve active destination. `Read` `.specify/memory/constitution.md` and apply constraints. Load stack-relevant guidelines.

Check `~/.gemini/antigravity-ide/sdd/preferences.json`:
- If file missing -> create with `{ "caveman_mode": false }`.
- If `caveman_mode: true` -> load `_shared/caveman/CAVEMAN.md` (Full mode rules) and display:
  > 🪨 Caveman mode is active (compact responses). Type `caveman off` any time to disable it.
- Honor `caveman on` / `caveman off` commands at any point during the session.

### 1. Resolve `tasks.md`

The user should provide `tasks.md` (handoff from `speckit_plan`) or it will be resolved:

```
Glob: {destination}/.specify/specs/*/tasks.md
```

| Situation | Action |
|---|---|
| Path provided in handoff | `Read` directly |
| Multiple `tasks.md` found | List and ask user (pt-BR) to choose one |
| None found | Redirect to `speckit_plan` |

### 2. Identify next task

Read `tasks.md`. Find the **first** `- [ ]` item.

- If no pending task:
  - Ask user (pt-BR):
    > *"Todas as tarefas desta spec estao concluidas! 🎉 Verifique se ha specs abertas em outras features."*
  - Stop.
- If found: show task and Ask user (pt-BR):
  > *"Vou executar: **{task title}**. Posso prosseguir? (sim / nao)"*

### 3. Read plan and spec context

`Read` `plan.md` and `spec.md` from the same NNN folder. Use as design and scope context.

### 4. Implement

- Write production code in **English** (identifiers, comments, log messages).
- Follow architecture from `constitution.md` and `plan.md`.
- Write/update automated tests when required by the task.
- Do not code outside current task scope.

### 5. Run tests

Execute local automated tests:

| Stack | Command |
|---|---|
| .NET | `dotnet test` |
| Node.js | `npm test` |
| Python | `pytest` |
| Other | Use runner from `constitution.md` or ask user |

If tests fail:
- Fix before marking task complete.
- If unable to fix, report error before stopping.

### 6. Update `tasks.md`

After implementation is validated by tests:
1. `Read` the resolved `tasks.md`.
2. Replace `- [ ] **Task N**` with `- [x] **Task N**` for completed task.
3. `Write` updated `tasks.md`.
4. Ask user (pt-BR):
   > *"✅ Tarefa `{title}` marcada como concluida em `{path to tasks.md}`."*

### 7. Suggest commit

Generate a conventional commit suggestion:

```
feat(<scope>): <short description of the change>

<optional body with details>

Refs: .specify/specs/NNN-<slug>/spec.md
```

Ask user (pt-BR):
> *"Deseja que eu execute o commit agora com `use skill commit`? (sim / nao)"*

## STOP - Session end

After completing one task, stop the session and hand off only. Do not implement another task in the same session unless the user explicitly requests it.

## Must not

- Write code in Portuguese
- Create new `spec.md`, `plan.md`, or `tasks.md` in this session
- Mark task complete without running tests
- Implement more than one task per session (unless explicitly requested)
- Modify `constitution.md` during implementation

## Handoff

```
use skill speckit_develop - {path to tasks.md}    (next task)
use skill commit                                    (commit changes)
```
