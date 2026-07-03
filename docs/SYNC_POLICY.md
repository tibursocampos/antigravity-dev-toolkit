# Cross-toolkit sync policy

How **antigravity-dev-toolkit** and **cursor-dev-toolkit** stay aligned.

## Canonical direction

| Content type | Source of truth | Port to |
|--------------|-------------------|---------|
| Stack skills, `_shared` guidelines (git, frontend, devops, dotnet extras) | antigravity -> cursor | `sync-cursor.ps1` paths |
| Rules granularity, hooks, `developer_common`, `format_validators` | cursor -> antigravity | `sync-antigravity.ps1` + KI/GUARDRAILS |
| Operational skills (`add_migrations`, `create_message_consumer`) | cursor -> antigravity | snake_case folders |
| Impeccable `reference/*.md` + router | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) -> cursor | `skills/impeccable/` via `sync-impeccable-refs.ps1` - **not** from antigravity personas |
| Frontend stack skills (`vue_developer`, `blazor_developer`, `electron_developer`) | cursor (authored) | Ported to antigravity (`plugin/skills/`) |
| Blip plugin skill + `blip_guidelines/` | cursor (authored) | Ported to antigravity (`blip_plugin_developer`) - manual sync |
| `dev_persona` | antigravity only | **Not ported** - Cursor uses `rules/` + `AGENTS.md` |
| Documentation architecture | Each repo adapts to its IDE model | See `docs/core-architecture.md` (Antigravity) / `docs/architecture.md` (Cursor) |

## Naming

- **Cursor:** kebab-case folders (`dotnet-developer`).
- **Antigravity:** snake_case folders (`dotnet_developer`).
- Do not normalize names across repos during port; adapt paths only.

## Validation after port

**Antigravity:**

```powershell
.\scripts\sync-antigravity.ps1
.\scripts\validation\validate-all.ps1
```

**Cursor:**

```powershell
.\scripts\sync-cursor.ps1
.\scripts\validation\validate-all.ps1
```

## CI

Both repos run `validate-all.ps1` on pull requests via `.github/workflows/validate-toolkit.yml`.
