---
name: developer
description: >
  Generic development skill. Acts as a smart router for heavy frameworks (delegating to specialized stack skills) OR
  acts directly as a Senior Fullstack/DevOps engineer for ad-hoc scripts, HTML, and automation tasks.
  Use when the user says "use skill developer" or requests generic coding without specifying a stack.
---

## STOP - Read before ANY tool call

1. Read `{pluginRoot}/GUARDRAILS.md`
2. Read `_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`
3. If the relevant gate is not approved: **STOP** - ask user **(pt-BR)** - do **NOT** Write/Shell
4. SDD/develop skills: after **ONE** step/task, **STOP** session - handoff only
5. This skill body is **English**; user-facing prompts may be **(pt-BR)**

### Step -1 - Gate check (report in chat before continuing)

```

### Step -1b - Caveman Mode (Full cap)
1. Read `~/.gemini/antigravity-ide/sdd/preferences.json` (create `{ "caveman_mode": false, "caveman_level": "full" }` if missing).
2. If `caveman_mode` is false: continue without compression.
3. If true: load `{pluginRoot}/skills/_shared/caveman/CAVEMAN.md`; apply **Full** participation cap + prefs `caveman_level` (Lite skills never escalate); show once: `[Caveman] Modo ativo (respostas compactas, level={effective}). Digite caveman off para desativar.`
4. Honor `caveman on|off|status|lite|full|ultra` (and `stop caveman` / `normal mode`) during the session.
5. Auto-Clarity + never-compress gates/drafts/paths per `CAVEMAN.md`.
Gate check:
[ ] GUARDRAILS.md read
[ ] SESSION.md read; session-state loaded
[ ] User confirmed current action (sim)
-> If any unchecked: STOP
```

---

## Trigger

Use when user asks for `use skill developer` or requests generic coding/refactoring tasks without specifying a stack.

## Outcome

Correct stack skill loaded and executed, or ad-hoc implementation in fallback mode with optional handoff to `use skill commit`.

## Lazy-load (only when needed)

| When | Path (after `scripts/sync-antigravity.ps1`) |
|------|----------------------------------------|
| Git / language policy | `dev_persona`, `dev_persona` |
| Developer flow | `{pluginRoot}/skills/_shared/developer_common/GUIDE.md` |
| Context pressure | `dev_persona` |
| Caveman Mode (if active) | `{pluginRoot}/skills/_shared/caveman/CAVEMAN.md` |

Load `dev_persona` for branch and context policy when needed.

## Frontend design routing

Before UI implementation, check project context:

1. If the task is **net-new UI** or a **visual redesign** and `PRODUCT.md` is missing -> recommend `use skill impeccable init` first (new session).
2. If `docs/DESIGN-BRIEF.md` (or `docs/design/DESIGN-BRIEF.md`) exists -> treat it as acceptance source; delegate to the matching `*-developer` skill **without reinterpreting visual decisions**.
3. One session = design (`impeccable shape`) **or** implementation (`*-developer`), not both.

Premium UI without a brief -> suggest `use skill impeccable shape` before stack implementation.

## Routing Logic

1. **Inspect the workspace** - identify stack in this order (frameworks before generic Node):

   | Signal | Route to |
   |--------|----------|
   | User asks for **new** Blip plugin scaffold (no existing `blip-ds` project) | `blip_plugin_developer` |
   | `package.json` with `blip-ds` and `iframe-message-proxy` (existing Blip plugin) | `react_developer` (loads `blip_guidelines/`) |
   | `.csproj` with `Microsoft.AspNetCore.Components`, or `_Imports.razor` / `App.razor` | `blazor_developer` |
   | `package.json` with `electron`, `electron-builder`, or `electron-vite` | `electron_developer` |
   | `package.json` with `vue` (and not React/Angular) | `vue_developer` |
   | `package.json` with `react` | `react_developer` |
   | `package.json` with `@angular/core` or `angular` | `angular_developer` |
   | `package.json` (Node.js, no framework above) | `javascript_developer` |
   | `.csproj` / `.sln` without Blazor markers | `dotnet_developer` |
   | `.py`, `requirements.txt`, `pyproject.toml` | `python_developer` |

2. **Invoke the specialized skill (if match found)**:
   - Silently read the `SKILL.md` of the matched stack under `{pluginRoot}/skills/`:
     - `blip_plugin_developer`, `blazor_developer`, `electron_developer`, `vue_developer`, `dotnet_developer`, `react_developer`, `angular_developer`, `javascript_developer`, or `python_developer`
   - Assume the identity and instructions of that skill immediately.
   - Do **not** ask the user for confirmation to switch skills.

3. **Fallback mode (if no match found)**:
   - If no major framework structure is detected (e.g., isolated `.html`, `.sh`, `.bat`, `.ps1` files), **do not delegate**.
   - Assume the task directly using standard, secure engineering practices as a Senior Developer.
   - Proceed to the Execution Process below.

## Execution Process (fallback mode only)

### 0. Workspace

Confirm target repo, read `README.md` (if exists), and summarize requested acceptance.

### 1. Micro-plan

Define 2-5 concrete tasks. Checkpoint context usage after each major change per dev_persona context management.

### 2. Implement

Write clean, maintainable code following universal best practices for the target language (e.g., HTML, Bash, Python script).

### 3. Tests / Validation

Run local scripts or linting tools to ensure the code executes without syntax errors.

### 4. Handoff

Offer `use skill commit`. Do not commit automatically.

## Must not

- Auto-commit or auto-PR
- Leave AI traces in code comments or identifiers (see GUARDRAILS.md AI stealth section)
- Delegate when a clear stack match exists

## Handoff

| Situation | Next |
|-----------|------|
| Commit | `use skill commit` |
| .NET work (explicit) | `use skill dotnet_developer` |
| Large scope | `use skill sdd_spec` -> `sdd-plan` -> `sdd-develop` |
| UI design / brief | `use skill impeccable` (`shape` / `craft`) |
| New Blip plugin scaffold | `use skill blip_plugin_developer` |
