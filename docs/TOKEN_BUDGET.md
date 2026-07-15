# Token budget - antigravity-dev-toolkit

Guidelines for using and extending this toolkit without blowing context or cost.

## Bundled content sizes

| Package | Default sync |
|---------|--------------|
| `dotnet_guidelines` | Yes |
| `developer_common` | Yes (ported from cursor toolkit) |
| SDD skills (`sdd_spec`, `sdd_plan`, `sdd_develop`) | Yes |
| Stack `*_developer` skills | Yes - lazy on invoke |
| `format_validators` | Yes |
| `code_guidelines/principles` | Yes |
| Full `code_guidelines/languages/*` | Deferred - use stack guidelines |

## Golden rules

1. **One step = one session** for `sdd_develop` / Forma C O3 / `document_implement`.
2. **Never preload entire `_shared`** - lazy-load per skill table.
3. **SKILL.md ≤ 500 lines** - use `reference.md` for templates (`validate-skills-structure.ps1` enforces).
4. **Lean router** - `AGENTS.md` and `dev_persona` stay pointers, not full guideline paste.
5. **KI injection** - `sync-antigravity.ps1` writes summaries; do not duplicate full GUARDRAILS in every skill.

## Stack skills

Each `*_developer` skill loads only its stack guidelines + `developer_common` steps when needed.

See cursor-dev-toolkit `TOKEN_BUDGET.md` for detailed tier targets when porting skills across repos.
