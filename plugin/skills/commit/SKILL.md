---
name: commit
description: >
  Review staged and unstaged changes, draft a Conventional Commits message, and commit on a valid
  feature branch. Use when the user says "use skill commit", "commit changes", or "/commit".
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

# Skill: commit

## Trigger

Use for `use skill commit`, `commit changes`, or `/commit`.

## Outcome

Approved Conventional Commit(s) on a valid feature branch, then optional handoff to `use skill push`.

## Process

### -1. Re-check guardrails and session

If missing, ask user (pt-BR):

```text
Antes do commit, confirme:
- GUARDRAILS.md lido
- SESSION.md carregado

Posso seguir? (sim / ajustar / cancelar)
```

### 0. Validate branch

Allowed: `feature/<slug>`, `feat/<id>`.  
Blocked: `main`, `master`, `develop`, invalid patterns.

### 1. Inspect changes

```bash
git status
git diff --staged
git diff
git log --oneline -10
```

### 2. Draft message

Use Conventional Commits, present message, and wait for explicit approval.

### 3. Commit

Stage explicit paths and commit with approved message only.

### 4. Ask for push (pt-BR)

```text
Commit realizado com sucesso. Deseja enviar para o remoto? (sim / nao)
```

## Must not

- Commit on blocked branches
- Auto-commit without message approval
- Add AI co-author trailers
- Use tracker APIs or forced workflow templates
