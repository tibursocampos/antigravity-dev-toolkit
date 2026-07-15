# Skills catalog - antigravity-dev-toolkit

Canonical underscore skill folders under `plugin/skills/`. Invoke with `use skill <name>` (or `/name` when the IDE maps it).

Also listed in `plugin/skills/dev_persona/SKILL.md` (router).

## Formas (A / B / C)

| Forma | Skills | Guide |
|-------|--------|-------|
| **A** Classic SDD | `sdd_spec`, `sdd_plan`, `sdd_develop` | [01-sdd-workflow](guides/01-sdd-workflow.md) |
| **B** Backlog prep | `refine_backlog_item`, `breakdown_tasks` | [guides README](guides/README.md) |
| **C** Orchestrated | `memory_bank_init` (Step 0), `orchestrate_analyze`, `orchestrate_deliver`, `orchestrate_develop` | [10-forma-c](guides/10-forma-c-orquestracao.md) · [11 NuGet](guides/11-forma-c-caso-nuget-extract.md) · [12 mobile](guides/12-forma-c-caso-mobile-app.md) |

**Storage:** Classic + Forma C artifacts under `features/NNN-slug/`; memory-bank co-located via manifest (`STORAGE.md`). Spec Kit was **removed**.

## Classic SDD (Forma A)

| Skill | Purpose |
|-------|---------|
| `sdd_spec` | Create PRD (pt-BR default) under `features/NNN-slug/` |
| `sdd_plan` | Baby-step PLAN from PRD |
| `sdd_develop` | Execute one PLAN step per session |

## Forma C - orchestration

| Skill | Purpose |
|-------|---------|
| `memory_bank_init` | Create/refresh `memory-bank/` (Step 0 for O1/O2/O3) |
| `orchestrate_analyze` | O1: Step 0 + triage, serial specialists, FEATURE + US/TS + CONTINUITY |
| `orchestrate_deliver` | O2: Step 0 + `sdd_spec`/`sdd_plan` per story; multi-path handoff |
| `orchestrate_develop` | O3: Step 0 + one `sdd_develop` session per PLAN step; parent never codes |

Antigravity runs specialists as **serial passes** (no Cursor Task/hooks). See `_shared/agents/SUBAGENT-MODEL.md`.

## Developer routing and stack

| Skill | Purpose |
|-------|---------|
| `dev_persona` | Central AG router (language, git, catalog) — toolkit-only |
| `developer` | Hybrid router: detects stack and delegates, or fallback for ad-hoc scripts |
| `dotnet_developer` | Small/medium .NET work without full SDD |
| `react_developer` | Small/medium React work without full SDD |
| `angular_developer` | Small/medium Angular work without full SDD |
| `vue_developer` | Small/medium Vue 3 work without full SDD |
| `blazor_developer` | Small/medium Blazor UI without full SDD |
| `electron_developer` | Small/medium Electron apps without full SDD |
| `javascript_developer` | Small/medium JavaScript/Node work without full SDD |
| `python_developer` | Small/medium Python work without full SDD |

## Blip plugins / Impeccable

| Skill | Purpose |
|-------|---------|
| `blip_plugin_developer` | Scaffold Blip React extensions; handoff to `react_developer` |
| `impeccable` | UI/UX design router; shape -> `docs/DESIGN-BRIEF.md` |

## Operational

| Skill | Purpose |
|-------|---------|
| `code_review` | Structured review; asks single vs multi-angle if omitted |
| `fix_build` | Diagnose/fix build and tests |
| `test_coverage` | .NET Coverlet coverage report |
| `commit` | Conventional commit on valid branch |
| `push` | Safe git push after confirmation |
| `add_migrations` | EF Core migration discovery |
| `create_message_consumer` | Message consumer scaffold |
| `refactor` | Safe incremental refactoring |
| `api_integrate` | Typed API clients from OpenAPI |
| `performance_profile` | Profiling and optimization |
| `containerize` | Dockerfiles and compose |
| `i18n_manager` | Extract strings to resource files |

## Documentation (RAG)

| Skill | Purpose |
|-------|---------|
| `document_plan` | Baby-step documentation plan |
| `document_implement` | Execute one documentation plan step |

## Breaking changes (v Forma C)

- Spec Kit skills (`speckit_*`) removed — use Forma A or Forma C.
- Root flat `PRD/` / `PLAN/` no longer valid write destinations — use `features/NNN-slug/`.
