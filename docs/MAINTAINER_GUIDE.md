# Maintainer guide - antigravity-dev-toolkit

Reference for repository layout, deploy, validation, and conventions.

| Field | Value |
|-------|--------|
| **Install target** | `~/.gemini/antigravity-ide/plugins/` via `scripts/sync-antigravity.ps1` |
| **Smoke test** | `scripts/validation/validate-all.ps1` after sync |
| **Skills catalog** | [docs/SKILLS.md](SKILLS.md) |

## Repository layout

```
antigravity-dev-toolkit/
├── AGENTS.md
├── README.md
├── plugin/
│   ├── plugin.json
│   ├── GUARDRAILS.md
│   └── skills/              # deployed to Antigravity plugin dir
│       ├── sdd_spec/, … stack *_developer/
│       ├── impeccable/, blip_plugin_developer/
│       ├── add_migrations/, create_message_consumer/
│       └── _shared/           # sdd_artifacts, guidelines, developer_common, format_validators
├── docs/                      # incl. impeccable-integration.md, blip-plugin-integration.md
└── scripts/                 # sync-antigravity.ps1, toolkit.ps1, validation/, maintainers/
```

## Skills (36 folders)

See [SKILLS.md](SKILLS.md). Naming: **snake_case** folders; frontmatter `name` may use hyphen.

**Frontend / Blip:** `impeccable` (design router), `blip_plugin_developer` (new Blip extension scaffold). Shared packs: `blip_guidelines/`, `react_guidelines/`, `frontend_guidelines/`, `html_css_guidelines/`, etc. Integration docs: [impeccable-integration.md](impeccable-integration.md), [blip-plugin-integration.md](blip-plugin-integration.md).

## Deploy and validate

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/sync-antigravity.ps1
.\scripts\validation\validate-all.ps1
```

Or: `.\scripts\toolkit.ps1` (interactive menu).

## Checklist: new skill

1. **English** - SKILL.md body in English; user prompts may be pt-BR.
2. **Gate block** - copy from `plugin/skills/_shared/SKILL_TEMPLATE.md` or run `maintainers/inject-skill-gates.ps1`.
3. **Size policy** - `SKILL.md` hard limit **500 lines**. Warn at 350. See [TOKEN_BUDGET.md](TOKEN_BUDGET.md).
4. **Catalog** - add entry to `docs/SKILLS.md`.
5. **Integration doc** - for ecosystem skills (e.g. `impeccable`, `blip_plugin_developer`), add or extend `docs/*-integration.md`.
6. **Sync + validate** - `sync-antigravity.ps1` then `validate-all.ps1`.

## Impeccable reference sync

```powershell
.\scripts\maintainers\sync-impeccable-refs.ps1
```

## Shared packs (ported from cursor-dev-toolkit)

| Folder | Purpose |
|--------|---------|
| `_shared/developer_common/` | Git-only developer workflow steps |
| `_shared/format_validators/` | Commit/PR/feature format validators |

## Session gates

Path: `~/.gemini/antigravity-ide/sdd/sessions/{repo-hash}.json` - see `SESSION.md`.

## Cross-toolkit sync

See [SYNC_POLICY.md](SYNC_POLICY.md) for canonical direction when equalizing with cursor-dev-toolkit.
