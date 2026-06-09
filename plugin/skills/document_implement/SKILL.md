---
name: document_implement
description: >
  Execute the next pending step from docs/documentation-plan/plan.md in the open workspace.
  Updates plan progress and writes domain docs for RAG. Use when the user says
  "use skill document_implement", "document repo", or "/document_implement". Requires a plan;
  handoff to document_plan if missing.
---

# Skill: document_implement

## Trigger

Invoke when the user asks for: `use skill document_implement`, `document repository`, `/document_implement`, or `execute documentation plan`.

Requires `docs/documentation-plan/plan.md` in the **target workspace**. If missing, hand off to `use skill document_plan` (do not invent steps).

## Outcome

One **documentation plan step** completed in the target repo: new/updated markdown under `docs/`, plan progress advanced, next step identified for a future session.

## Lazy-load

| When | Path |
|------|------|
| SDD vs RAG plan boundary | `_shared/sdd_artifacts/STORAGE.md` |
| Contexto | `dev_persona` § Gestão de Contexto |

## Process

### 0. Workspace, plan, and stack

1. Confirm **target repository**.
2. Read `docs/documentation-plan/plan.md`. If absent → stop and suggest `use skill document_plan`.
3. Read **Doc language** from plan header. If missing, ask: **pt-BR** or **English** before writing `docs/`.
4. Re-detect stack briefly if plan is stale (Glob: `*.sln`, `*.csproj`, `package.json`, etc.).

**Not SDD:** only `docs/documentation-plan/plan.md` applies here — not workspace `PLAN/PLAN_*.md`. For feature delivery PRD/PLAN, use `sdd_spec` / `sdd_plan` / `sdd_develop` and `STORAGE.md`.

### 1. Select step

Pick the first step with **Status:** Pending (or **Pendente**) whose dependencies are completed. If user names a step id, use that step after validating deps.

Summarize objective and deliverables; ask to proceed if scope is large.

### 2. Execute step

Follow the step's **Tasks** in the plan:

- Glob/Grep/Read source; document facts evidenced in code/config
- Write paths listed in **Deliverables** (e.g. `docs/domains/<slug>.md`)
- Use **doc language** from plan; keep file paths and type names in English
- No secrets, tokens, or internal-only URLs in markdown

### 3. Update plan

Edit `docs/documentation-plan/plan.md` in place:

| Field | Value |
|-------|-------|
| Step status | Completed / Concluído |
| **Completed:** | `YYYY-MM-DD` |
| Deliverables / acceptance | `[x]` when met |
| Progress | `N/M` |
| **Next step** | following pending step |

### 4. Context checkpoint

After the step, follow `dev_persona` § Gestão de Contexto. At **≥ 40%**, save plan + docs and pause — do not start the next plan step in the same session.

### 5. Report

Files written, step completed, progress `N/M`, suggested handoff.

## Must not

- Run without `docs/documentation-plan/plan.md` (unless user gives an explicit alternate plan path)
- Assume fixed stack versions without detection
- Write product `docs/` before doc language is known
- Complete multiple plan steps in one session when context is high
- Require Azure DevOps or external wiki APIs

## Handoff

| Situação | Próximo |
|----------|---------|
| No plan | `use skill document_plan` |
| Next doc step (new chat) | `use skill document_implement` |
| All steps done | `use skill code_review` (opcional) or `use skill commit` |
| Feature code change | `use skill sdd_spec` → `sdd_plan` → `sdd_develop` |
