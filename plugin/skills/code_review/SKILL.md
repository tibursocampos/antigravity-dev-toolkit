---
name: code-review
description: >
  Review a branch or diff against PRD/PLAN acceptance, project standards, and shared guidelines.
  Produces a structured report (critical, important, nice-to-have). Use when the user says
  "use skill code-review", "review this PR", or "/code-review". Git-only with optional gh usage.
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

# Skill: code-review

## Trigger

Use for `use skill code-review`, `/code-review`, PR review, or branch/diff quality validation.

## Outcome

A structured review report in pt-BR with severity levels and final decision:
- Approved
- Approved with reservations
- Changes required

## Process

### -1. Re-check guardrails and session

If missing, ask user (pt-BR):

```text
Antes da review, confirme:
- GUARDRAILS.md lido
- SESSION.md carregado

Posso seguir? (sim / ajustar / cancelar)
```

### -2. Resolve scope and artifacts

Identify base/head, then discover PRD/PLAN (`PRD/*.md`, `docs/PRD/*.md`, `PLAN/PLAN_*.md`) and map by id.

### 0. Analyze diff

```bash
git diff <base>...<head> --stat
git diff <base>...<head>
git log <base>..<head> --oneline
```

### 1. Review dimensions

Evaluate:
- Correctness
- Architecture boundaries
- Test quality and regression risk
- Security
- Performance
- Maintainability

### 2. Verify execution

Run build/tests when feasible. Use coverage evidence when required by PRD/PLAN/user.

### 3. Deliver report

Reference `path:line`, explain why, suggest fixes, and include clear final decision.

## Must not

- Edit PRD/PLAN in this skill
- Auto-approve, auto-merge, or rewrite code without request
- Depend on corporate tracker APIs
- Include AI co-author text anywhere
