# AGENTS.md — Full Guardrails Contract

This file is the human-readable guardrails reference for the toolkit repository.

## Scope

Applies to all toolkit skills, including SDD, Spec Kit, developer, operational, infrastructure, and frontend architecture skills (e.g., `blip_plugin_developer`).

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
- `sdd_develop`, `speckit_develop`, and `document_implement` execute one step per session.
- Tests must run before marking a step complete.

## Language policy

- Chat replies: `pt-BR`.
- Skill source (`SKILL.md`) and guardrail documents: English.
- Production code, tests, identifiers, and commit/PR text: English.
- SDD artifacts default to `pt-BR` unless user explicitly asks for English in that invocation.

## Manifest and storage policy (v2)

- Manifest file: `~/.gemini/antigravity-ide/sdd/manifest.json`.
- Schema version: `2`.
- Per-repository sections:
  - `classic`: storage mode/path for `sdd_*`.
  - `speckit`: storage mode/path/init state for `speckit_*`.
- First run prompts user for storage mode(s); decisions are persisted.

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
- `scripts/validation/validate-speckit-init.ps1` (optional via `-IncludeSpeckit`)

Maintainer suite (utility scripts not required for normal usage):
- `scripts/maintainers/`

## Skill naming and invocation

- Skill folder names are underscore-based (example: `breakdown_tasks`).
- Keep docs and examples aligned with folder names.
- Hyphenated names may exist in frontmatter for matching, but docs should prefer underscore skill commands.

## Caveman mode

Persisted in `~/.gemini/antigravity-ide/sdd/preferences.json` as `caveman_mode`.

- `caveman on`: enable compact responses.
- `caveman off`: disable compact responses.
- `caveman status`: report current mode.

Never compress confirmation gates, artifact drafts, or safety messages.

## Optional frontend workflows

| Flow | Steps |
|------|--------|
| Frontend design -> implement | `impeccable shape` -> `DESIGN-BRIEF.md` -> `*_developer` (one session per step) |
| Blip plugin scaffold -> implement | `blip_plugin_developer` -> SDD/spec -> `react_developer` (one session per step) |
| Net-new UI without brief | `use skill impeccable init` or `impeccable shape` before stack implementation |

Integration docs: [docs/impeccable-integration.md](docs/impeccable-integration.md), [docs/blip-plugin-integration.md](docs/blip-plugin-integration.md).

Stack developers: `react_developer`, `angular_developer`, `vue_developer`, `blazor_developer`, `electron_developer`, `javascript_developer`. See [docs/guides/08-stack-developers.md](docs/guides/08-stack-developers.md).
