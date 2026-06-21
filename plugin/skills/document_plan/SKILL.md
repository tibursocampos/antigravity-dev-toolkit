---
name: document_plan
description: >
  Create a baby-step documentation plan for the target workspace (overview + domain deep dives).
  Detect stack via repo inspection and ask doc language before writing product docs.
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

# Skill: document_plan

## Trigger

Use for `use skill document_plan`, `plan repo docs`, or `/document_plan`.

## Outcome

- `docs/documentation-plan/plan.md`
- `docs/overview.md` (unless user provides a reviewed equivalent)

## Process

### -1. Re-check guardrails and session

If missing, ask user (pt-BR):

```text
Antes de planejar a documentacao, confirme:
- GUARDRAILS.md lido
- SESSION.md carregado

Posso seguir? (sim / ajustar / cancelar)
```

### 0. Confirm target and language

Detect stack and ask once before writing `docs/` (pt-BR prompt):

```text
Qual idioma da documentacao de produto em `docs/`? (pt-BR / English)
```

### 1. Discover existing artifacts

Check existing plan and overview files and decide resume/overwrite with user confirmation.

### 2. Write overview and plan

Create/update concise overview and a step-by-step documentation plan with status and progress.

### 3. Handoff

Recommend `use skill document_implement` for next pending step.

## Must not

- Write product docs before language confirmation
- Assume fixed stack without discovery
- Mix this flow with SDD `PLAN/PLAN_*.md`
