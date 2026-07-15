# SDD pipeline guards (spec / plan / implement)

Execution order, Antigravity mode behavior, canonical paths, confirmation gates, and missing-artifact dialogs. Load at **step -1** of `sdd_spec`, `sdd_plan`, `sdd_develop`, and Forma C `orchestrate_*` - do not paste into PRD/PLAN bodies.

Install path after sync: `{pluginRoot}/skills/_shared/sdd_artifacts/PIPELINE.md`

Companion: `STORAGE.md` (folders, manifest, `.gitignore`).

## Work forms (A / B / C)

| Form | Flow | Canonical writes |
|------|------|------------------|
| **A** Classic | `sdd_spec` -> `sdd_plan` -> `sdd_develop` | `features/NNN-slug/USnn/{PRD,PLAN}/` (default story `US01`) |
| **B** Backlog | `refine_backlog_item` -> `breakdown_tasks` (-> optional SDD / developer) | Prefer `features/.../STORY.md` + story subfolders; `docs/backlog/` shortcut |
| **C** Orchestrated | **Step 0** memory-bank gate -> `orchestrate_analyze` -> `orchestrate_deliver` -> `orchestrate_develop` **or** manual `sdd_develop` | Same `features/` tree; CONTINUITY between stages; bank co-located via manifest (`$Cwd/memory-bank/` or `<classic.path>/memory-bank/`) |

Forms coexist (A / B / C only). **Forma A** does **not** require memory-bank. Gate contract: `MEMORY-BANK.md`.

## Skill order

- **Classic SDD (Forma A)**: Fixed sequence: **`sdd_spec` -> `sdd_plan` -> `sdd_develop`**. Never skip a stage unless shortcut selected. Memory-bank optional.
- **Forma C**: Fixed sequence: **Step 0 (Memory Bank Gate, policy `auto`) -> `orchestrate_analyze` (O1) -> `orchestrate_deliver` (O2) -> (`orchestrate_develop` (O3) \| `sdd_develop`)** after human gates. Each `orchestrate_*` re-checks Step 0 before its flow. O2 reuses `sdd_spec` / `sdd_plan` contracts per story. O3 reuses `sdd_develop` contract (**one PLAN step per session**) and runs Step N **refresh-light** after code changes.

| Skill | Writes | Must not in same session |
|-------|--------|---------------------------|
| `spec` | PRD + manifest under feature story | PLAN; production/test code (`*.cs`, migrations, etc.) |
| `plan` | PLAN + manifest under feature story | PRD body; production/test code |
| `sdd_develop` | Code (English) + PLAN progress | New PRD/PLAN files; **multiple PLAN steps** |
| `memory_bank_init` | Resolved `bank_root` (+ `.inventory/`) | App code; bank under `features/`; edit `.gitignore` in global mode |
| `orchestrate_analyze` | Feature tree + STORY + CONTINUITY (incl. Memory-bank ref) | App code; skip Step 0 / human backlog approval |
| `orchestrate_deliver` | PRD/PLAN per story (via sdd contracts) | App code; skip Step 0 when wired |
| `orchestrate_develop` | CONTINUITY + handoff one PLAN step; Step N refresh-light | App code in parent; multi-step in one child; skip Step 0 when wired |

## Canonical paths

### Valid PRD (classic - new writes)

Preferred (Forma A / C):

- `features/NNN-slug/USnn/PRD/NNN_*.md` or `features/NNN-slug/TSnn/PRD/NNN_*.md` (workspace)
- `~/.gemini/antigravity-ide/sdd/<repo-id>/features/NNN-slug/USnn/PRD/NNN_*.md` (global; or manifest classic path)

Forma A when story unspecified: use **`US01`**.

`NNN` = three digits. Slug after underscore in filename.

### Valid PLAN (classic - new writes)

- `features/NNN-slug/USnn/PLAN/PLAN_NNN_*.md` (or `TSnn`)
- Global equivalent under `<classic.path>/features/...`

PLAN `NNN` **must match** source PRD `NNN`.

### Forbidden paths (not used)

Do **not** read, write, or continue Classic SDD from:

- Repo-root `PRD/` / `PLAN/` / `docs/PRD/` / `docs/PLAN/` (gitignore safety net only - not an active flow)
- Global-flat `~/.gemini/antigravity-ide/sdd/<repo-id>/PRD/` or `.../PLAN/` outside `features/`
- Loose `REFINE/`, `ANALYSIS/`, `ARCH/`, `SEC/` at repo root
- `~/.gemini/antigravity-ide/` outside `sdd/<repo-id>/features/` (classic)
- `docs/backlog/*.md`, arbitrary `docs/*.md`, repo-root `*.md` without feature tree

### Promote non-canonical `.md`

1. `Read` the file the user cited.
2. Build PRD (or PLAN) content per `spec/reference.md` or `plan/reference.md`.
3. Run § Confirm before write.
4. `Write` only under `features/NNN-slug/[USnn|TSnn]/{PRD|PLAN}/`.
5. Do not delete the old file unless the user asks.

Manifest folders must resolve per `STORAGE.md` schema v2 (`features/` root).

## Antigravity mode - Phase A / Phase B

**Product limit:** In **Plan** and **Ask** modes, `Write`/`Edit` and often shell are blocked. User “permission” in chat does **not** enable disk writes.

| Phase | Modes | Actions |
|-------|-------|---------|
| **A - Collect & draft** | Plan, Ask, Agent | Questions, `Read`/Glob/Grep, PRD/PLAN draft in chat, content approval |
| **B - Persist** | **Agent** only | `Write` PRD/PLAN after § Confirm; `sdd_develop` code; `test_coverage` runs |

| Mode | `sdd_spec` / `sdd_plan` | `sdd_develop` | `test_coverage` |
|------|-----------------|-------------|-----------------|
| Agent | Write after confirm | Allowed | Allowed |
| Plan | Phase A only; no `Write`; never claim “saved” | Draft/analysis only; no `Edit` on code | Explain tests need Agent |
| Ask | Same as Plan | Block code changes | Block test execution |

### Phase A complete - prompt user (pt-BR)

Copy when content is approved but disk write or tests are still pending:

```text
Rascunho aprovado. Para gravar o arquivo em `{path}` (ou executar testes),
altere para o modo **Agent** e envie:

/<nome> - gravar

(Opcional: cole o caminho do PRD/PLAN se já tiver sido definido.)
```

If the user insists on staying in Plan: continue Phase A only; **never** state “PRD/PLAN salvo em …” without a successful `Write`.

## Confirm before write (spec and plan)

Always before the first `Write` of a **new** PRD or PLAN (and when replacing an empty draft file):

1. Show: title, `NNN`, **full resolved path** under `features/...`, storage mode, 3-5 content bullets, planned status.
2. Ask (pt-BR): **“Posso gravar em `{path}`? (sim / ajustar / cancelar)”**
3. `Write` only after explicit **sim**.
4. **ajustar** -> revise draft in chat, ask again. **cancelar** -> do not write.

`sdd_develop` updates the existing PLAN file after completing a step without re-asking storage (per `context-management.mdc`).

## Prior context (chat, Plan, code_review, feature tree)

When the thread already has requirements, review findings, or refined backlog:

- Do **not** run the full `spec` questionnaire.
- Provide a structured summary + **at most 3** gap questions.
- Map code_review items to PRD sections (acceptance criteria, risks, out of scope) per `spec/reference.md`.

### Feature / story siblings (Forma A / C)

When the working path is under `features/NNN-slug/` (or the user names that feature):

1. `Read` `FEATURE.md` and `CONTINUITY.md` at the feature root when present.
2. `Read` sibling story files under the same feature: `STORY.md`, optional `REFINE/`, `ANALYSIS/`, `ARCH/`, `SEC/`, and existing `PRD/` / `PLAN/` for that story.
3. Prefer sibling content over re-asking; still max **3** gap questions.
4. Keep parent chat lean: summarize + paths; do not paste full guideline bodies.

If no `features/` artifacts exist, do **not** fall back to root `PRD/`/`PLAN/` - ask the user to create via `sdd_spec` / Forma C.

## Missing canonical artifact - ask before handoff

Use **one** structured question (pt-BR). Do not invent PRD/PLAN or write code in this step.

### `plan` without PRD on disk

```text
Não encontrei um PRD em features/**/PRD/NNN_*.md (nem sob ~/.gemini/antigravity-ide/sdd/<repo-id>/features/...).

Como prefere continuar?

1) Criar o PRD primeiro (recomendado para SDD completo)
2) Montar o PLAN direto - você envia as especificações na próxima mensagem
```

| Choice | Next step |
|--------|-----------|
| **1** | Ask: *“Envie as orientações do PRD (texto) ou o caminho de um arquivo .md para analisar.”* -> run **`spec`** (Phase A; persist in Agent). Handoff when PRD exists: `use skill sdd_plan - <full-prd-path>` |
| **2** | Ask: *“Envie as especificações (texto) ou o caminho de um arquivo para análise.”* -> analyze -> PLAN draft in chat; note ideal SDD has a PRD; persist PLAN only with canonical path + § Confirm. Suggest option **1** if scope is large |

Explicit “criar PRD” while invoking `plan` -> treat as choice **1**; do not write PLAN until a canonical PRD exists unless user chose **2**.

### `sdd_develop` without PLAN on disk

```text
Não encontrei um PLAN em features/**/PLAN/PLAN_NNN_*.md (nem sob ~/.gemini/antigravity-ide/sdd/<repo-id>/features/...).

1) Criar PRD + PLAN antes (spec -> plan)
2) Só criar o PLAN - você envia PRD ou especificações na próxima mensagem
3) Você já tem um arquivo de plano - informe o caminho sob features/ (será validado/promovido se necessário)
```

| Choice | Action |
|--------|--------|
| **1** | Guide to `spec` (use § plan without PRD, choice **1**) then `plan` |
| **2** | If canonical PRD exists -> `sdd_plan`; else ask for specs or file (same as plan choice **2** inputs) |
| **3** | `Read` path; if invalid -> promote per § Promote |

### Path validation helper

Before `Write`, confirm the target matches **new-write** patterns:

- PRD: `features/[^/]+/(US|TS)\d+/PRD/\d{3}_.+\.md` (workspace-relative) or same under `.../sdd/<repo-id>/features/`
- PLAN: `features/[^/]+/(US|TS)\d+/PLAN/PLAN_\d{3}_.+\.md` or global equivalent

Root or flat `PRD/` / `PLAN/` paths are **invalid** for Classic SDD - promote under `features/` before write/develop.

### Forma A path example (full)

```text
features/004-export-profile/US01/PRD/004_export_profile.md
features/004-export-profile/US01/PLAN/PLAN_004_export_profile.md

/sdd_plan - features/004-export-profile/US01/PRD/004_export_profile.md
/sdd_develop - features/004-export-profile/US01/PLAN/PLAN_004_export_profile.md - Step 1
```

If validation fails, do not write - fix path or promote.

## Integration

| Consumer | Use |
|----------|-----|
| `sdd_spec`, `sdd_plan`, `sdd_develop` | Step -1 load; steps reference § by name |
| `orchestrate_*` | Forma C order; feature Prior context; CONTINUITY |
| `refine_backlog_item`, `breakdown_tasks` | Forma B; prefer feature STORY paths |
| `STORAGE.md` | Folders, manifest, invalid-path summary |
| `{pluginRoot}/GUARDRAILS.md` | Short always-on reminder |
| `code_review` | Handoff to `sdd_spec` for new PRD; read-only SDD discovery |
| `test-coverage` | Phase B / Agent for shell; report paths in `reference.md` |
