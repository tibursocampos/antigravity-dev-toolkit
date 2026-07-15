---
name: javascript-developer
description: >
  Implement or fix small-to-medium JavaScript/Node.js features without full SDD. Uses Node.js, Express/Nest,
  DOM manipulation, npm/yarn, and Git-only developer flow. Use for isolated JS/TS work.
  For larger cross-cutting features, route to sdd_spec -> sdd_plan -> sdd_develop.
---

## STOP - Read before ANY tool call

1. Read `{pluginRoot}/GUARDRAILS.md`
2. Read `_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`
3. If the relevant gate is not approved: **STOP** - ask user **(pt-BR)** - do **NOT** Write/Shell
4. SDD/develop skills: after **ONE** step/task, **STOP** session - handoff only
5. This skill body is **English**; user-facing prompts may be **(pt-BR)**

### Step -1 - Gate check (report in chat before continuing)

```
Gate check:
[ ] GUARDRAILS.md read
[ ] SESSION.md read; session-state loaded
[ ] PIPELINE.md read (SDD / orchestrate skills only)
[ ] User confirmed current action (sim)
-> If any unchecked: STOP
```

---

## Trigger

Use when user asks for `use skill javascript-developer`, `js fix`, `node fix`, or a small isolated JavaScript/TypeScript implementation.

## Outcome

Working JS/TS code and tests in the target workspace, validated with tests/build, with optional handoff to `use skill commit`.

## When to escalate to SDD

Recommend `sdd-spec` -> `sdd-plan` -> `sdd-develop` for multi-service, large API surface, or 10+ file changes.

## DESIGN-BRIEF acceptance

If `docs/DESIGN-BRIEF.md` or `docs/design/DESIGN-BRIEF.md` exists with `target_stack: html-css`, treat it as the acceptance source. Map to DOM/vanilla or light libs; do **not** reinterpret visual decisions.

If the task is net-new UI without a brief, recommend `use skill impeccable shape` in a **new session** before implementing.

## Lazy-load references

| When | Path |
|------|------|
| Design brief | `docs/DESIGN-BRIEF.md` or `docs/design/DESIGN-BRIEF.md` |
| Branch / commit | `dev_persona`, `{pluginRoot}/skills/_shared/developer_common/step-3-branching.md` |
| JavaScript guidelines | `{pluginRoot}/skills/_shared/javascript_guidelines/` |
| Frontend core (`html-css` / DOM work) | `{pluginRoot}/skills/_shared/frontend_guidelines/frontend-practices.md` |
| DOM patterns (`html-css` stack) | `{pluginRoot}/skills/_shared/javascript_guidelines/dom-patterns.md` |
| Markup / styles (`html-css` stack) | `{pluginRoot}/skills/_shared/html_css_guidelines/` |
| Principles | `{pluginRoot}/skills/_shared/code_guidelines/principles/` |
| Context | `dev_persona` |
| Caveman Mode (if active) | `{pluginRoot}/skills/_shared/caveman/CAVEMAN.md` |

Do not preload unrelated guideline trees.

## Process

### Step -1b - Caveman Mode (Full cap)
1. Read `~/.gemini/antigravity-ide/sdd/preferences.json` (create `{ "caveman_mode": false, "caveman_level": "full" }` if missing).
2. If `caveman_mode` is false: continue without compression.
3. If true: load `{pluginRoot}/skills/_shared/caveman/CAVEMAN.md`; apply **Full** participation cap + prefs `caveman_level` (Lite skills never escalate); show once: `[Caveman] Modo ativo (respostas compactas, level={effective}). Digite caveman off para desativar.`
4. Honor `caveman on|off|status|lite|full|ultra` (and `stop caveman` / `normal mode`) during the session.
5. Auto-Clarity + never-compress gates/drafts/paths per `CAVEMAN.md`.

### 0. Workspace

Confirm Node/JS project (`package.json`). Summarize acceptance.

### 1. Guidelines

Load only required JavaScript/TypeScript guidelines for this task.

### 2. Branch

Use `feature/<slug>` or `feat/<id>`.

### 3. Micro-plan

Define 3-7 concrete tasks; checkpoint context at >= 40%.

### 4. Implement

Node.js/JS ecosystem best practices. Match existing patterns.

### 5. Tests

Jest/Mocha/Vitest per project configuration.

### 6. Validate

```bash
npm test
npm run build
```

### 7. Handoff

Offer `use skill commit`. Do not commit automatically.

## Must not

- Auto-commit or auto-PR
- Leave AI traces in code or identifiers

## Handoff

| Situation | Next |
|-----------|------|
| Commit | `use skill commit` |
| Review | `use skill code_review` |
| Scope grew | `sdd-spec` -> `sdd-plan` -> `sdd-develop` |
| Missing design brief | `use skill impeccable shape` (new session) |
