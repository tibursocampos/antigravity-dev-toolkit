# AGENTS.md — Full Guardrails Contract

This file is the human-readable guardrails reference for the toolkit repository.

## Scope

Applies to all toolkit skills, including SDD Formas A/B/C, developer, operational, infrastructure, and frontend architecture skills (e.g., `blip_plugin_developer`).

## Enforcement model

Antigravity IDE currently has no native local hooks equivalent to Cursor hook blocking. Enforcement is layered:

1. `plugin/GUARDRAILS.md` (source of hard rules)
2. `global_guardrails` KI injected by `scripts/sync-antigravity.ps1`
3. `custom_skills` KI for skill discovery behavior
4. `SESSION.md` gates + per-repo session-state files
5. Gate-first Step -1 block in each skill

Do not claim "`dev_persona` is always active" without explaining KI-based enforcement.

## Mandatory start sequence (every conversation)

Before any tool call:

1. Read `plugin/GUARDRAILS.md`.
2. Read `plugin/skills/dev_persona/SKILL.md`.
3. Read `plugin/skills/_shared/sdd_artifacts/SESSION.md`.
4. Resolve session-state for current repo and required gate.
5. If user has not confirmed with `sim`, stop and ask.

## Non-negotiable rules

- No automatic mutating git commands (`commit`, `push`, `merge`, `rebase`, branch creation).
- Read-only git inspection is allowed (`status`, `diff`, `log`).
- New artifact writes require explicit confirmation.
- `sdd_develop`, Forma C O3, and `document_implement` execute one step per session.
- Tests must run before marking a step complete.
- New Classic / Forma C writes land under `features/NNN-slug/` (see `STORAGE.md`). Root flat `PRD/` / `PLAN/` are not valid destinations.

## Language policy

- Chat replies: `pt-BR`.
- Skill source (`SKILL.md`) and guardrail documents: English.
- Production code, tests, identifiers, and commit/PR text: English.
- SDD artifacts default to `pt-BR` unless user explicitly asks for English in that invocation.

## Manifest and storage policy (v2)

- Manifest file: `~/.gemini/antigravity-ide/sdd/manifest.json`.
- Schema version: `2`.
- Per-repository section:
  - `classic`: storage mode/path for `sdd_*` and Forma C (`features/` + co-located `memory-bank/`).
- First run prompts user for storage mode; decisions are persisted.
- Legacy `speckit` keys in old manifests are **ignored** (Spec Kit removed).

## Workflows (Formas A / B / C)

| Forma | When | Pipeline |
|-------|------|----------|
| **A** Classic SDD | One feature, clear path | `sdd_spec` -> `sdd_plan` -> `sdd_develop` |
| **B** Backlog prep | Informal item before SDD | `refine_story` -> `split_story_checklist` -> A or C |
| **C** Orchestrated | Multi-story / brownfield / specialists | Step 0 memory-bank -> `orchestrate_analyze` -> `orchestrate_deliver` -> (`orchestrate_develop` \| `sdd_develop`) |

Guides: `docs/guides/10-forma-c-orquestracao.md`, `11-forma-c-caso-nuget-extract.md`, `12-forma-c-caso-mobile-app.md`.

**Forma C note (Antigravity):** O1/O2 use **serial specialist passes** (no Cursor `Task`/hooks). O3 = one `sdd_develop` step per session; parent never writes app code in bulk.

## Session-state gates

Session files are stored under:

`~/.gemini/antigravity-ide/sdd/sessions/{repo-hash}.json`

Required gate checks:

- `storage_confirmed`
- `write_confirmed`
- `step_confirmed`
- `tests_run`

## Validation scripts

Primary entry point:

- `scripts/toolkit.ps1` — central interactive orchestrator (sync, tests, maintainer suite)
- `scripts/validation/validate-all.ps1` — post-sync smoke test (deploy, structure, docs, English)

Individual checks (also invoked by `validate-all.ps1`):

- `scripts/validation/validate-toolkit-deploy.ps1`
- `scripts/validation/validate-skills-structure.ps1`
- `scripts/validation/validate-docs-consistency.ps1`
- `scripts/validation/validate-skills-english.ps1`
- `scripts/validation/validate-impeccable-skill.ps1`
- `scripts/validation/validate-blip-plugin-skill.ps1`
- `scripts/validation/validate-frontend-ecosystem.ps1`
- `scripts/validation/validate-session-gates.ps1` (optional via `-IncludeSessionGate`)

Maintainer suite (utility scripts not required for normal usage):
- `scripts/maintainers/`

## Skill naming and invocation

- Skill folder names are underscore-based (example: `split_story_checklist`).
- Keep docs and examples aligned with folder names.
- Prefer `use skill skill_name` invoke form.

## Caveman mode

Persisted in `~/.gemini/antigravity-ide/sdd/preferences.json` as `caveman_mode` + `caveman_level` (`lite`|`full`|`ultra`).

- `caveman on` / `off` / `status` / `lite|full|ultra`
- Contract: `plugin/skills/_shared/caveman/CAVEMAN.md` (lazy). Compact prose files: `COMPACT.md`.
- Never compress confirmation gates, artifact drafts, or safety messages. `commit`/`push` are NEVER.

## Optional frontend workflows

| Flow | Steps |
|------|--------|
| Frontend design -> implement | `impeccable shape` -> `DESIGN-BRIEF.md` -> `*_developer` (one session per step) |
| Blip plugin scaffold -> implement | `blip_plugin_developer` -> SDD/spec -> `react_developer` (one session per step) |
| Net-new UI without brief | `use skill impeccable init` or `impeccable shape` before stack implementation |

Integration docs: [docs/impeccable-integration.md](docs/impeccable-integration.md), [docs/blip-plugin-integration.md](docs/blip-plugin-integration.md).

Stack developers: `react_developer`, `react_native_developer`, `angular_developer`, `vue_developer`, `blazor_developer`, `electron_developer`, `javascript_developer`. See [docs/guides/08-stack-developers.md](docs/guides/08-stack-developers.md).
