# Core Architecture

## Plugin layer

The toolkit is deployed as a local Antigravity plugin:
- Manifest: `plugin/plugin.json`
- Rule root: `plugin/GUARDRAILS.md`
- Skills: `plugin/skills/<skill_name>/SKILL.md`
- Shared references: `plugin/skills/_shared/`

## Enforcement layers

Because Antigravity currently lacks native local hooks for hard tool interception, this toolkit uses layered enforcement:

1. **Plugin guardrails** (`GUARDRAILS.md`)
2. **Knowledge items** injected at sync:
   - `custom_skills`
   - `global_guardrails`
3. **Session-state gates** from `SESSION.md`
4. **Gate-first Step -1 blocks** in all skills

This is why docs must explain KI-based enforcement when discussing always-on behavior.

## Storage architecture (manifest v2)

Storage decisions are resolved by:

`~/.gemini/antigravity-ide/sdd/manifest.json`

Schema v2 stores Classic SDD / Forma C under:

- `classic` for `sdd_*` and `orchestrate_*` (`features/` + co-located `memory-bank/`)

Each `classic` entry supports:
- `storage_mode: repository | global`
- `path`

Legacy `speckit` keys from older manifests are ignored (Spec Kit removed).

## Session-state architecture

Per-repo state:

`~/.gemini/antigravity-ide/sdd/sessions/{repo-hash}.json`

Gates:
- `storage_confirmed`
- `write_confirmed`
- `step_confirmed`
- `tests_run`

These gates are the runtime contract before Write/Shell actions.

## Deployment pipeline

`scripts/sync-antigravity.ps1` performs idempotent SHA-256 synchronization and KI updates.

Recommended validation sequence:

1. `validate-toolkit-deploy.ps1`
2. `validate-docs-consistency.ps1`
3. `validate-skills-english.ps1`
