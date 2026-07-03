---
name: blip_plugin_developer
description: >
  Orchestrate new Blip React plugin projects using create-blip-extension (CRA scaffold), config:plugin setup,
  SDD/Spec Kit documentation flow, and handoff to react_developer or impeccable. Use when the user says
  "use skill blip_plugin_developer", "blip plugin", or wants to scaffold a Blip extension. Not for backend-only work.
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
[ ] PIPELINE.md read (SDD/speckit skills only)
[ ] User confirmed current action (sim)
-> If any unchecked: STOP
```

---

## Trigger

- User asks for `use skill blip_plugin_developer`, `blip plugin`, or a **new** Blip React extension
- User wants scaffold + documentation setup before implementation

For **existing** Blip plugin repos ( `blip-ds` in `package.json` ), use `use skill react_developer` instead.

## Outcome

A correctly scaffolded Blip plugin repo with `config:plugin` applied, profile documented, SDD/Spec Kit path chosen, and clear handoff to implementation skills.

## Lazy-load references

| When | Path (after `sync-antigravity.ps1`) |
|------|--------------------------------|
| Integration overview | `docs/blip-plugin-integration.md` (in target or toolkit repo) |
| Architecture | `{pluginRoot}/skills/_shared/blip_guidelines/plugin-architecture.md` |
| Design system | `{pluginRoot}/skills/_shared/blip_guidelines/design-system.md` |
| Iframe messages | `{pluginRoot}/skills/_shared/blip_guidelines/blip-iframe-messages.md` |
| Auth (Full profile) | `{pluginRoot}/skills/_shared/blip_guidelines/auth-and-permissions.md` |
| External API | `{pluginRoot}/skills/_shared/blip_guidelines/external-api-integration.md` |
| Deploy / CI | `{pluginRoot}/skills/_shared/blip_guidelines/deploy-and-ci.md` |
| React guidelines | `{pluginRoot}/skills/_shared/react_guidelines/` |
| Frontend practices | `{pluginRoot}/skills/_shared/frontend_guidelines/frontend-practices.md` |
| Design brief template | `{pluginRoot}/skills/impeccable/reference/DESIGN-BRIEF-TEMPLATE.md` |
| Branch / commit | `dev_persona` |

Do not preload unrelated guideline trees.

## Must not (defaults)

- Use `cra-template-blip-plugin` (microbundle) as scaffold default
- Clone ADO `package-plugin-template` silently without user confirmation
- Skip `npm run config:plugin`
- Skip `sdd_spec` / `speckit_spec` when starting SDD from scratch
- Hand off to removed Antigravity persona skills (use `impeccable shape` or `react_developer` instead)
- Mix backend API implementation into the plugin scaffold session

## Process

### Phase 1 - Scaffold (infrastructure first)

Ask the user **(pt-BR)**:

1. "Onde deseja criar o projeto do plugin? (diretÃ³rio atual `./` ou informe caminho e nome `<plugin-name>`)"
2. "Qual perfil? **Lite** (pÃ¡gina Ãºnica, sem auth) ou **Full** (multi-rota, AuthProvider, buckets)?"
3. "O plugin consome API REST externa (ex.: .NET) ou apenas resources Blip?"

Wait for answers before running scaffold commands.

**Official scaffold:**

```powershell
npm create blip-extension@latest <plugin-name>
cd <plugin-name>
npm install
npm run config:plugin
```

- `config:plugin` replaces `PLUGIN_NAME` in charts and `appsettings.json`
- Remove template `.git` only if the user wants a fresh repo history (`Remove-Item -Recurse -Force .git` on Windows)
- Update `.gitignore` for agent artifacts (`PRD/`, `PLAN/`, `.specify/` if desired locally)

**Portal checklist (document for user):**

- Blip portal -> advanced settings -> Plugins JSON
- Register local URL `http://localhost:3000` for dev smoke
- Never commit API keys or portal tokens

**Validate before Phase 2:**

```powershell
npm run build
```

Document manual smoke: `npm start` -> open inside Blip portal -> verify iframe height and toast.

**Optional internal template (not default):** ADO `package-plugin-template` only if user explicitly requests and confirms access. Do not fallback silently.

### Phase 2 - Documentation flow

Ask **(pt-BR)**: "Qual fluxo de documentacao? (SDD, Spec Kit, PRD/brief existente, ou escopo informal?)"

| Choice | Next command (new session each step) |
|--------|--------------------------------------|
| **SDD** | `use skill sdd_spec` -> `use skill sdd_plan` -> `use skill sdd_develop` |
| **Spec Kit** | `use skill speckit_spec` -> `use skill speckit_plan` -> `use skill speckit_develop` |
| **Existing PRD/brief** | Skip spec; proceed to `sdd_plan` or `speckit_plan` with provided doc |
| **Informal / small** | Document scope in `README.md`; handoff directly to implementation |

**Do not** jump to `sdd_plan` without a PRD/spec when starting SDD from scratch.

Record profile (Lite/Full) and API type (Blip resources vs external REST) in PRD or README.

### Phase 3 - Handoff (implementation)

Ask **(pt-BR)** what to implement next. Route by scope:

| Scope | Next step |
|-------|-----------|
| Net-new UI / redesign | `use skill impeccable shape` -> `docs/DESIGN-BRIEF.md` with `target_stack: react` and Blip/BDS notes in section 9 |
| Plugin implementation | `use skill react_developer` (auto-loads `blip_guidelines/` when `blip-ds` present) |
| Backend API (.NET) | `use skill dotnet_developer` in **separate repo** - not in plugin scaffold session |

**DESIGN-BRIEF:** use template at `{pluginRoot}/skills/impeccable/reference/DESIGN-BRIEF-TEMPLATE.md`. One session = design **or** implementation, not both.

**External API:** if Phase 1 answer was REST backend, remind user to read `external-api-integration.md` during `react_developer` sessions.

## Reference profiles

| Profile | Reference repo | Notes |
|---------|----------------|-------|
| **Lite** | `blip-na-produtization` | Single route, BDS web components, no AuthProvider |
| **Full** | `blip-stellantis-plugin` | Multi-route, AuthProvider, buckets, blip-ds-react |

Load `auth-and-permissions.md` only for Full profile.

## Handoff

| Situation | Next |
|-----------|------|
| Implement UI/features | `use skill react_developer` |
| Design new screens | `use skill impeccable shape` |
| Backend API | `use skill dotnet_developer` (separate repo) |
| Full SDD feature | `use skill sdd_spec` |
| Commit (after implementation) | `use skill commit` |

## Related docs

Toolkit maintainer doc: `docs/blip-plugin-integration.md`
