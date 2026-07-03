# Impeccable integration (antigravity-dev-toolkit)

Upstream: [pbakaus/impeccable](https://github.com/pbakaus/impeccable) - vendored at `skill-v3.9.1` via `plugin/skills/impeccable/reference/`. **Not** the deprecated Antigravity persona skills (`impeccable_developer`, `impeccable_ui`, etc.).

## Three levels (do not confuse)

| Level | What | Project install? |
|-------|------|------------------|
| **1 - Toolkit skill** | `use skill impeccable` + lazy-loaded `reference/<cmd>.md` | **No** - synced via `sync-antigravity.ps1` |
| **2 - Detector bridge** | `npx impeccable detect --json <paths>` during `audit` | **No** - transient npx |
| **3 - Per-project setup** | `npx impeccable install` (live mode, design hook, `.impeccable/`) | **Yes** - explicit user consent only |

Daily shape -> brief -> implement **does not** require level 3.

## Invoke

```
use skill impeccable
use skill impeccable shape [feature]
use skill impeccable audit [paths]
```

## Handoff contract

1. `impeccable shape` (or craft shape phase) -> user confirms -> `docs/DESIGN-BRIEF.md`
2. New session -> `react_developer`, `angular_developer`, `vue_developer`, `blazor_developer`, `electron_developer`, `javascript_developer`, or `developer` router
3. Implementer reads brief; does not redesign in the same session

Template: `plugin/skills/impeccable/reference/DESIGN-BRIEF-TEMPLATE.md`

**Blip plugins:** when `target_stack` is `react` and the project uses `blip-ds`, add BDS / iframe constraints in brief section 9. For new Blip extensions, prefer `use skill blip_plugin_developer` for scaffold before `impeccable shape`. See [blip-plugin-integration.md](blip-plugin-integration.md).

## When `npx impeccable install` is needed

| Scenario | Install? |
|----------|----------|
| shape / polish / critique with toolkit refs | No |
| `npx impeccable detect` in audit | No |
| **Live mode** (browser variants) | Yes |
| **Design hook** (block slop on UI writes) | Yes |
| Shared `.impeccable/config.json` in repo | Yes |

The skill **must ask (pt-BR)** before running install. Never silent.

## Hooks and Antigravity limitations

Antigravity IDE does **not** have native hook blocking equivalent to Cursor `HOOKS.md`. See [antigravity-hooks-investigation.md](antigravity-hooks-investigation.md).

If the user requests live mode or design hook:

1. **STOP** - ask user **(pt-BR)** before `npx impeccable install`.
2. Document that project-level `.cursor/hooks.json` from Impeccable may not be enforced the same way in Antigravity.
3. Impeccable hook docs: `plugin/skills/impeccable/reference/hooks.md`.

## Project `.gitignore` snippet

Add to frontend projects using Impeccable artifacts:

```gitignore
# impeccable-ignore-start
.impeccable/config.local.json
.impeccable/hook.cache.json
.impeccable/hook.pending.json
.impeccable/*.png
.impeccable/live/server.json
.impeccable/live/sessions/
.impeccable/live/previews/
.impeccable/live/annotations/
.impeccable/live/cache/
.impeccable/live/manual-edit-apply-transaction.json
.impeccable/live/manual-edit-events.jsonl
.impeccable/live/manual-edit-evidence/
.impeccable/live/pending-manual-edits.json
.impeccable/live/deferred-svelte-component-accepts.json
.impeccable/live/*.png
# impeccable-ignore-end
```

**Keep tracked:** `.impeccable/config.json`, `.impeccable/live/config.json`, `.impeccable/design.json`, `.impeccable/critique/*.md`

## Migration (from deprecated personas)

Projects with `.agents/AGENTS.md` referencing `impeccable_developer` or sub-personas:

1. Replace with flow: `use skill impeccable shape` -> `docs/DESIGN-BRIEF.md` -> `use skill react_developer` (or matching stack).
2. Remove persona-specific rules from project `AGENTS.md`.
3. Do not invoke `impeccable_ui`, `impeccable_components`, `impeccable_state`, or `impeccable_a11y` — use `use skill impeccable <command>` instead.

## Maintainer sync

Refresh references from local upstream clone:

```powershell
.\scripts\maintainers\sync-impeccable-refs.ps1
.\scripts\maintainers\sync-impeccable-refs.ps1 -SourcePath D:\Source\Repos\impeccable -Tag skill-v3.9.1
```

Preserves toolkit-only files: `DESIGN-BRIEF-TEMPLATE.md`.

## Validation

```powershell
.\scripts\validation\validate-impeccable-skill.ps1
```

Bundled with `validate-all.ps1`.

## Alternative: upstream-only install

Teams that prefer zero vendoring can run `npx impeccable install` in each project and skip the toolkit skill. The toolkit router still recommends `impeccable shape` before `*_developer` when `PRODUCT.md` is missing.
