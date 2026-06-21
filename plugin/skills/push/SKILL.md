---
name: push
description: >
  Execute git push on the current branch. Use when the user says "use skill push",
  "push changes", or "/push".
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

# Skill: push

## Trigger

Use for `use skill push`, `push changes`, or `/push`.

## Process

### -1. Re-check guardrails and session

If missing, ask user (pt-BR):

```text
Antes do push, confirme:
- GUARDRAILS.md lido
- SESSION.md carregado

Posso seguir? (sim / ajustar / cancelar)
```

### 0. Validate branch

Allowed: `feature/<slug>`, `feat/<id>`.  
Blocked: `main`, `master`, `develop`, invalid patterns.

### 1. Push

```bash
git push -u origin HEAD
```

Never force-push protected/default branches.

### 2. Report

Return branch and push status.

## Must not

- Push from invalid branch
- Force push default branches
