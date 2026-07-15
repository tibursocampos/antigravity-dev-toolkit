# Guide 08: Stack developer skills

Stack-specific skills for small-to-medium work **without** a full SDD cycle. Use when the stack is known or when `developer` routes to one of these skills automatically.

## Skills

| Skill | Invoke | When |
|-------|--------|------|
| `dotnet_developer` | `use skill dotnet_developer` | `.sln` / `.csproj` (API/backend), isolated .NET change |
| `blazor_developer` | `use skill blazor_developer` | Blazor UI (WASM, Server, or Hybrid) |
| `react_developer` | `use skill react_developer` | React app; existing Blip plugins load `blip_guidelines/` |
| `angular_developer` | `use skill angular_developer` | Angular app, components/services |
| `vue_developer` | `use skill vue_developer` | Vue 3 app, Composition API |
| `electron_developer` | `use skill electron_developer` | Electron desktop (main/preload/renderer) |
| `blip_plugin_developer` | `use skill blip_plugin_developer` | **New** Blip React plugin scaffold (not existing repos) |
| `javascript_developer` | `use skill javascript_developer` | Node/JS/TS without React/Angular/Vue |
| `python_developer` | `use skill python_developer` | Python services, scripts, FastAPI/Flask |

## Router detection order

`developer` inspects the workspace in this order (first match wins):

| Priority | Signal | Routes to |
|----------|--------|-----------|
| 1 | `.csproj` with Blazor markers or `_Imports.razor` / `App.razor` | `blazor_developer` |
| 2 | `package.json` with `electron` / `electron-builder` / `electron-vite` | `electron_developer` |
| 3 | `package.json` with `blip-ds` + `iframe-message-proxy` (existing Blip plugin) | `react_developer` (+ `blip_guidelines/`) |
| 4 | `package.json` with `vue` | `vue_developer` |
| 5 | `package.json` with `react` | `react_developer` |
| 6 | `package.json` with `@angular/core` | `angular_developer` |
| 7 | `package.json` (generic Node) | `javascript_developer` |
| 8 | `.csproj` / `.sln` without Blazor | `dotnet_developer` |
| 9 | Python markers | `python_developer` |

For **new** Blip plugin projects (no repo yet), invoke `use skill blip_plugin_developer` explicitly instead of relying on router detection.

## Blip plugin flow

1. `use skill blip_plugin_developer` -> scaffold + profile (Lite/Full)
2. `sdd_spec` -> `sdd_plan` -> `sdd_develop` (or Forma C)
3. Optional: `impeccable shape` -> `docs/DESIGN-BRIEF.md`
4. `use skill react_developer` for implementation

See [blip-plugin-integration.md](../blip-plugin-integration.md).

## Frontend design handoff

For net-new UI or visual redesign:

1. `use skill impeccable shape` (design session) -> `docs/DESIGN-BRIEF.md`
2. New session -> matching `*_developer` per `target_stack` in the brief

See [impeccable-integration.md](../impeccable-integration.md).

## Router vs explicit invoke

- **`use skill developer`** - inspects the workspace and delegates silently to the matching stack skill.
- **`use skill dotnet_developer`** (etc.) - skip detection; use when you already know the stack.

See [02-developer.md](02-developer.md) for the router and [02b-dotnet_developer.md](02b-dotnet_developer.md) for .NET-specific detail.

## When to escalate to SDD

Use `sdd_spec` -> `sdd_plan` -> `sdd_develop` (or Forma C) when **two or more** apply:

- 3+ architectural layers touched
- Schema/migration changes
- Cross-repo or new integrations
- 10+ files or 4+ hours estimated
- Approved PLAN already exists

## Engineering utilities (any stack)

For cross-cutting utilities, see [05-operational-skills.md](05-operational-skills.md):

- `refactor`, `api-integrate`, `performance-profile`, `containerize`, `i18n-manager`

These may hand off to `developer` (router) or a stack skill for local edits.

## Post-code workflow

On a valid feature branch:

1. `use skill code-review`
2. `use skill test-coverage` (.NET repos with tests)
3. `use skill commit`
