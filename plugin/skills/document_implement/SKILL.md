---
name: document_implement
description: >
  Execute the next pending step from docs/documentation-plan/plan.md in the target workspace.
  Update plan progress and write domain docs. If no plan exists, hand off to document_plan.
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

# Skill: document_implement

## Trigger

Use for `use skill document_implement`, `document repo`, or `/document_implement`.

## Outcome

One documentation plan step completed with updated docs and updated progress.

## Process

### -1. Re-check guardrails and session

If missing, ask user (pt-BR):

```text
Antes de executar o plano de documentacao, confirme:
- GUARDRAILS.md lido
- SESSION.md carregado

Posso seguir? (sim / ajustar / cancelar)
```

### 0. Load plan and language

Require `docs/documentation-plan/plan.md`. If missing, stop and hand off to `use skill document_plan`.
Use doc language from plan header; if missing, ask user in pt-BR.

### 1. Execute one pending step

Pick first valid pending step (or user-selected step with dependency validation), write deliverables, and avoid secrets.

### 2. Update plan state

Mark step completed, update date and progress, and identify next pending step.

### 3. Report and handoff

Return changed doc paths + progress and suggest next action.

## Must not

- Run without a documentation plan
- Write docs before language is defined
- Complete many plan steps in one high-context session
