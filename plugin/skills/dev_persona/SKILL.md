---
name: dev-persona
description: >
  Central router for the personal development toolkit. Defines language policy,
  git conventions, SDD workflow, context governance, and available skills.
  Use "use skill dev-persona" to load the full catalog and operating rules.
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
-> If any unchecked: STOP
```

---

# dev-persona - Central Router

Central router for `antigravity-dev-toolkit`. This document defines language policy, workflow routing, Git rules, context handling, Caveman behavior, and the skill catalog.

---

## Step -1 Requirements (always first)

Before any workflow:

1. Read `GUARDRAILS.md`.
2. Read `_shared/sdd_artifacts/SESSION.md` and load the current session state for `$Cwd`.
3. If KI is enabled for the current run, also apply KI `global_guardrails`.

Important:
- Do **not** assume KI `global_guardrails` are always active.
- KI `global_guardrails` apply **only** when KI is explicitly available/approved in the current execution context.

If any requirement is missing, stop and ask user (pt-BR):

```text
Antes de continuar, preciso confirmar os pre-requisitos:
- GUARDRAILS.md lido
- SESSION.md carregado
- (se aplicavel) KI global_guardrails ativo

Posso continuar? (sim / ajustar / cancelar)
```

---

## Language Policy

| Context | Rule |
|---|---|
| Chat responses to user | pt-BR |
| SDD artifacts (`PRD/*.md`, `PLAN/PLAN_*.md`) | pt-BR by default; English only if user asks in the same invocation |
| Source code, tests, identifiers, XML docs | English |
| Commit messages and PR title/body | English |
| Product docs (`docs/`, README, ADRs) | Ask user first (pt-BR or English) |
| Skill names, paths, command examples | English |

Keep standard dev terms in English (`branch`, `PR`, `commit`, `hook`, `skill`).

---

## Workflow Router

### Primary SDD flow

Use for medium/high complexity:

```text
sdd_spec -> sdd_plan -> sdd_develop
```

One `sdd_develop` session = one PLAN step. Then stop and hand off.

### Direct delivery shortcut

Use `developer` for small isolated work that does not need full SDD artifacts.

### Optional supporting flows

| Flow | Route |
|---|---|
| Build/test failure | `fix_build` -> `commit` (optional) |
| Coverage report | `test_coverage` |
| Review branch/diff | `code_review` |
| Commit and push | `commit` -> `push` |
| Repository documentation | `document_plan` -> `document_implement` |
| Backlog refinement | `refine_backlog_item` |
| Task breakdown | `breakdown_tasks` |

---

## SDD Guardrails

Canonical order:

```text
sdd_spec -> sdd_plan -> sdd_develop
```

Canonical paths:
- PRD: `PRD/NNN_*.md` or `docs/PRD/NNN_*.md`
- PLAN: `PLAN/PLAN_NNN_*.md`

Never place SDD artifacts in ad-hoc docs paths.

If PRD/PLAN is missing, ask user (pt-BR):

```text
Nao encontrei o PRD/PLAN canonico desta feature.
Opcoes:
1) Criar PRD agora com "use skill sdd_spec"
2) Voce informa o arquivo na proxima mensagem
3) Cancelar
```

Before creating new PRD/PLAN files, ask user (pt-BR):

```text
Posso gravar em `{path}`? (sim / ajustar / cancelar)
```

---

## Git Rules

### Conventional Commits

Use [Conventional Commits](https://www.conventionalcommits.org/):

```text
<type>[optional scope][!]: <description>
```

Allowed types:
`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

Never add AI co-author trailers.

Never reference AI, generation, or automation in commit title, body, or footer. Write commit messages as a human developer would.

Never leave AI traces in code comments, XML docs, identifiers, log messages, PR descriptions, or any artifact.

### Mutating Git actions

Do not run mutating git commands automatically. Require explicit user confirmation (`sim`) before `git add`, `git commit`, `git push`, branch creation, merge, or rebase.

### Branch validation

Allowed:
- `feature/<slug>`
- `feat/<id>`

Blocked:
- `main`, `master`, `develop`
- Any branch outside the allowed patterns

If blocked, stop and ask user (pt-BR) before creating a valid feature branch.

---

## Context Management

Manual monitoring policy:

| Estimated context usage | Action |
|---|---|
| `< 40%` | Continue |
| `>= 40%` | Save progress artifact and pause |
| `>= 80%` | Hard stop; do not accept `force continue` |

At the end of each multi-step checkpoint:
1. Persist progress.
2. Estimate context usage.
3. Apply the table above.

When pausing at `>= 40%`, ask user (pt-BR):

```text
EXECUCAO PAUSADA - contexto estimado alto.
Salvo: [path]
Ultimo passo: [id]
Proximo passo: [id]

Recomendado: iniciar nova conversa para continuar.
Para continuar nesta sessao, responda: force continue
```

---

## Caveman Mode

Caveman mode is optional response compression. Load `_shared/caveman/CAVEMAN.md` only when needed.

Boot behavior:
1. Read `~/.gemini/antigravity-ide/sdd/preferences.json` (or create `{ "caveman_mode": false }`).
2. If enabled, apply Caveman rules and announce in pt-BR:

```text
Modo Caveman ativo (respostas compactas). Digite `caveman off` para desativar.
```

Commands:
- `caveman on`
- `caveman off`
- `caveman status`

Participation:
- NEVER: `commit`, `push`, explicit confirmation blocks.
- LITE: planning-heavy skills.
- FULL: implementation/review/build/coverage/general chat.

---

## Skill Catalog

| Skill | Purpose |
|---|---|
| `sdd_spec` | Create PRD |
| `sdd_plan` | Create PLAN from PRD |
| `sdd_develop` | Execute one PLAN step |
| `speckit_setup` | Install Spec Kit prerequisites |
| `speckit_init` | Initialize `.specify/` and validate constitution |
| `speckit_spec` | Create `spec.md` under `.specify/specs/` |
| `speckit_plan` | Generate `plan.md` and `tasks.md` |
| `speckit_develop` | Execute one Spec Kit task |
| `developer` | Router: invokes the correct specialized developer skill based on stack |
| `impeccable` | Frontend design router (shape, audit, polish) -> DESIGN-BRIEF handoff |
| `dotnet_developer` | Small/medium C#/.NET implementation without full SDD |
| `python_developer` | Small/medium Python implementation without full SDD |
| `react_developer` | Small/medium React implementation without full SDD |
| `angular_developer` | Small/medium Angular implementation without full SDD |
| `javascript_developer` | Small/medium Node/JS/TS implementation without full SDD |
| `vue_developer` | Small/medium Vue 3 implementation without full SDD |
| `blazor_developer` | Small/medium Blazor UI implementation without full SDD |
| `electron_developer` | Small/medium Electron desktop implementation without full SDD |
| `fix_build` | Diagnose and fix build/test failures |
| `code_review` | Review branch/diff with severity report |
| `commit` | Prepare and create conventional commit |
| `push` | Push current branch |
| `test_coverage` | Generate .NET coverage report |
| `document_plan` | Build docs plan for repo |
| `document_implement` | Execute one docs plan step |
| `refine_backlog_item` | Refine backlog item with acceptance criteria |
| `breakdown_tasks` | Break a refined scope into grouped implementation tasks |
| `refactor` | Refactor safely with validation |
| `api_integrate` | Integrate API clients/contracts from schema |
| `performance_profile` | Profile bottlenecks and optimize |
| `containerize` | Create Docker/container setup |
| `i18n_manager` | Extract strings and apply localization flow |
| `add_migrations` | EF Core migration discovery and add |
| `create_message_consumer` | Message consumer scaffold (bus detected via Grep) |
| `blip_plugin_developer` | Orchestrate new Blip React plugin projects (create-blip-extension) |

---

## Shared Guidelines (lazy-load only)

- `_shared/dotnet_guidelines/clean-architecture.md`
- `_shared/dotnet_guidelines/csharp-patterns.md`
- `_shared/dotnet_guidelines/checklist.md`
- `_shared/code_guidelines/principles/`
- `_shared/sdd_artifacts/PIPELINE.md`
- `_shared/caveman/CAVEMAN.md`

Never preload full language trees or unrelated guideline folders.

---

## AI Stealth Policy

All deliverables must be indistinguishable from work produced without AI assistance.

| Deliverable | Rule |
|---|---|
| Code comments | Minimal - only when strictly necessary. No AI references. Prefer self-explanatory code. |
| XML documentation | Written as a human developer. No AI, generation, or automation references. |
| Commit messages | No AI references in title, body, or footer. |
| PR descriptions | No AI references. |
| `docs/`, `README.md`, ADRs | No AI authorship or generation references. |
| SDD / Spec Kit artifacts | No AI generation references. |
| Identifiers | No AI-derived names (`aiResult`, `llmResponse`, `generatedBy`, etc.). |
| Log messages | No AI references. |

Applies to every skill. See `GUARDRAILS.md` § 9.

---

## Toolkit Editing Note

Never commit user-specific absolute paths, secrets, tokens, or API keys.
Use placeholders and portable paths (`$HOME`, `~/.gemini/`, `<TOKEN>`).

Maintainer guide: `docs/MAINTAINER_GUIDE.md`  
Install: `docs/INSTALL.md`
