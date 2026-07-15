# Toolkit Overview

`antigravity-dev-toolkit` is a local Antigravity plugin focused on controlled delivery:
- gate-first execution
- strict guardrails
- SDD Formas A / B / C (`features/NNN-slug/` + optional Forma C memory-bank)
- Git-only engineering operations

## Core architecture

- `plugin/plugin.json`: plugin metadata
- `plugin/GUARDRAILS.md`: hard non-negotiable rules
- `plugin/skills/`: skill contracts
- `plugin/skills/_shared/`: shared references and runtime policies (incl. agents, templates, MEMORY-BANK)
- `scripts/`: sync and validation automation

## Enforcement stack

The toolkit relies on layered enforcement because Antigravity does not currently expose local hook interception:

1. `GUARDRAILS.md`
2. `global_guardrails` KI
3. `custom_skills` KI
4. session-state gates (`SESSION.md`)
5. Step -1 gate checks in every skill

## Storage model

Manifest v2 (`~/.gemini/antigravity-ide/sdd/manifest.json`) resolves classic workflow storage (`repository` or `global`). Legacy `speckit` keys are ignored.

## Language model

- Chat: `pt-BR`
- Code/tests/identifiers: English
- Skill documentation: English
- SDD artifacts: default `pt-BR` (English by explicit request)

## Skills

See [SKILLS.md](SKILLS.md) for the full catalog (includes Forma C and `dev_persona`).
