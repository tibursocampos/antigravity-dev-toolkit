# SDD pipeline guards (spec / plan / implement)

Execution order, canonical paths, confirmation gates, and missing-artifact dialogs. Load at **step -1** of `spec`, `plan`, and `implement` — do not paste into PRD/PLAN bodies.

Install path after sync: `~/.gemini/antigravity-ide/plugins/Local.raphadev.antigravity-dev-toolkit/skills/_shared/sdd_artifacts/PIPELINE.md`

Companion: `STORAGE.md` (folders, numbering, `.gitignore`).

## Skill order

Fixed sequence: **`spec` → `plan` → `implement`**. Never skip a stage unless the user explicitly chooses a documented shortcut (see § Missing artifacts).

| Skill | Writes | Must not in same session |
|-------|--------|---------------------------|
| `spec` | PRD | PLAN; production/test code (`*.cs`, migrations, etc.) |
| `plan` | PLAN | PRD body; production/test code |
| `implement` | Code (English) + PLAN progress | New PRD/PLAN files |

## Canonical paths

### Valid PRD

- `PRD/NNN_*.md` or `docs/PRD/NNN_*.md` (workspace)

`NNN` = three digits. Slug after underscore.

### Valid PLAN

- `PLAN/PLAN_NNN_*.md` (workspace)

PLAN `NNN` **must match** source PRD `NNN`.

### Forbidden final destinations

Do **not** treat these as SDD PRD/PLAN:

- `docs/backlog/*.md`, arbitrary `docs/*.md`, repo-root `*.md` without `NNN_` / `PLAN_NNN_`
- User-pasted paths that fail the patterns above

### Promote non-canonical `.md`

1. `Read` the file the user cited.
2. Build PRD (or PLAN) content per skill templates.
3. Run § Confirm before write.
4. `Write` only to a canonical path.
5. Do not delete the old file unless the user asks.

## Confirm before write (spec and plan)

Always before the first `Write` of a **new** PRD or PLAN (and when replacing an empty draft file):

1. Show: title, `NNN`, **full resolved path**, storage mode, 3–5 content bullets, planned status.
2. Ask (pt-BR): **"Posso gravar em `{path}`? (sim / ajustar / cancelar)"**
3. `Write` only after explicit **sim**.
4. **ajustar** → revise draft in chat, ask again. **cancelar** → do not write.

`implement` updates the existing PLAN file after completing a step without re-asking.

## Prior context (chat, code-review)

When the thread already has requirements, review findings, or refined backlog:

- Do **not** run the full `spec` questionnaire.
- Provide a structured summary + **at most 3** gap questions.
- Map code-review items to PRD sections (acceptance criteria, risks, out of scope).

## Missing canonical artifact — ask before handoff

Use **one** structured question (pt-BR). Do not invent PRD/PLAN or write code in this step.

### `plan` without PRD on disk

```text
Não encontrei um PRD em PRD/NNN_*.md (nem em docs/PRD/).

Como prefere continuar?

1) Criar o PRD primeiro (recomendado para SDD completo)
2) Montar o PLAN direto — você envia as especificações na próxima mensagem
```

| Choice | Next step |
|--------|-----------|
| **1** | Ask: *"Envie as orientações do PRD (texto) ou o caminho de um arquivo .md para analisar."* → run **`spec`**. Handoff quando PRD existir: `use skill plan — <full-prd-path>` |
| **2** | Ask: *"Envie as especificações (texto) ou o caminho de um arquivo para análise."* → analisar → rascunho do PLAN em chat; notar que SDD ideal tem um PRD; persistir PLAN somente com path canônico + § Confirm. Sugerir opção **1** se o escopo for grande |

Explicit "criar PRD" while invoking `plan` → treat as choice **1**; do not write PLAN until a canonical PRD exists unless user chose **2**.

### `implement` without PLAN on disk

```text
Não encontrei um PLAN em PLAN/PLAN_NNN_*.md.

1) Criar PRD + PLAN antes (spec → plan)
2) Só criar o PLAN — você envia PRD ou especificações na próxima mensagem
3) Você já tem um arquivo de plano — informe o caminho (será validado/promovido se necessário)
```

| Choice | Action |
|--------|--------|
| **1** | Guide to `spec` (use § plan without PRD, choice **1**) then `plan` |
| **2** | If canonical PRD exists → `plan`; else ask for specs or file |
| **3** | `Read` path; if invalid → promote per § Promote |

### Path validation helper

Before `Write`, confirm the target matches:

- If `storage_mode` is `repository` (workspace-relative):
  - PRD: `(PRD|docs/PRD)/\d{3}_.+\.md`
  - PLAN: `PLAN/PLAN_\d{3}_.+\.md`
- If `storage_mode` is `global` (absolute path under resolved path):
  - PRD: `.*[/\\]PRD[/\\]\d{3}_.+\.md$` or `.*[/\\]docs[/\\]PRD[/\\]\d{3}_.+\.md$`
  - PLAN: `.*[/\\]PLAN[/\\]PLAN_\d{3}_.+\.md$`

If validation fails, do not write — fix path or promote.

## Integration

| Consumer | Use |
|----------|-----|
| sdd_spec, sdd_plan, sdd_develop | Step -1 load; use § Path validation helper and STORAGE.md § Global Manifest and Dynamic Storage Resolution |
| `STORAGE.md` | Folders, numbering, invalid-path summary |
| `dev_persona` | Always-on pipeline reminder (inline in skill) |
| `code-review` | Handoff to `spec` for new PRD; read-only SDD discovery |
| `test-coverage` | Agent required for shell; report paths in skill body |
| `speckit_spec`, `speckit_plan`, `speckit_develop` | Step -1 load; use § Spec Kit path validation |

---

## Spec Kit path validation

> **Used by:** `speckit_spec`, `speckit_plan`, `speckit_develop`. Load at step -1 alongside `STORAGE.md`.

Before any `Write` to Spec Kit artifacts, validate that the path resolves to the canonical `.specify/` structure.

### Validation regexes (required)

| Artifact | Regex |
|---|---|
| `spec.md` | `.*\.specify[/\\]specs[/\\]\d{3}-[^/\\]+[/\\]spec\.md$` |
| `plan.md` | `.*\.specify[/\\]specs[/\\]\d{3}-[^/\\]+[/\\]plan\.md$` |
| `tasks.md` | `.*\.specify[/\\]specs[/\\]\d{3}-[^/\\]+[/\\]tasks\.md$` |
| `constitution.md` | `.*\.specify[/\\]memory[/\\]constitution\.md$` |

### Blocking rule

If the write path does **not** match the expected artifact regex:

1. **Do not write** — abort immediately.
2. Show in chat (pt-BR): *"Caminho inválido para artefato Spec Kit. O arquivo deve estar em `.specify/specs/NNN-<slug>/` com o nome correto. Operação cancelada."*
3. Log the attempted path for debugging.

### Confirm before write (Spec Kit)

Same semantics as the classic § Confirm before write, adapted for Spec Kit:

1. Show: spec title, `NNN`, **resolved absolute path**, storage mode, 3–5 content bullets.
2. Ask the user (pt-BR): **"Posso gravar em `{path}`? (sim / ajustar / cancelar)"**
3. `Write` only after explicit **sim**.
