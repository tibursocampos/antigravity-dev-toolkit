# Guide 06: Specialized Developer Skills

This guide covers stack-specific developers and engineering utilities.

## Stack-specific developer skills

| Skill | Stack |
|-------|-------|
| `dotnet_developer` | .NET API/backend (non-Blazor) |
| `blazor_developer` | Blazor UI (WASM, Server, Hybrid) |
| `react_developer` | React; existing Blip plugins auto-load `blip_guidelines/` |
| `angular_developer` | Angular |
| `vue_developer` | Vue 3 |
| `electron_developer` | Electron desktop |
| `javascript_developer` | Node/JS/TS without framework |
| `python_developer` | Python |
| `blip_plugin_developer` | **New** Blip React plugin scaffold only |

Router: `developer` delegates silently. See [08-stack-developers.md](08-stack-developers.md).

## Frontend design and Blip

| Skill | Purpose |
|-------|---------|
| `impeccable` | Design router (`shape`, `audit`, `polish`) -> `DESIGN-BRIEF.md` |
| `blip_plugin_developer` | Scaffold via `create-blip-extension` + SDD handoff |

Integration: [impeccable-integration.md](../impeccable-integration.md), [blip-plugin-integration.md](../blip-plugin-integration.md).

**DESIGN-BRIEF:** stack `*_developer` skills treat `docs/DESIGN-BRIEF.md` as acceptance source (section 10 = one session scope).

## Engineering utilities

- `refactor`
- `api_integrate`
- `performance_profile`
- `containerize`
- `i18n_manager`

## Common execution pattern

1. Analyze the target surface.
2. Present findings.
3. Choose execution path:
   - direct with `developer` or a stack-specific skill
   - full classic SDD (`sdd_spec` -> `sdd_plan` -> `sdd_develop`)
   - Spec Kit flow (`speckit_spec` -> `speckit_plan` -> `speckit_develop`)

## Safety rules

- Use underscore names in invocation and docs.
- Preserve confirmation gates and tests before completion.
- Escalate to structured SDD when scope exceeds direct implementation.
