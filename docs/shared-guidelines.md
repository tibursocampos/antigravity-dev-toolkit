# Shared Guidelines

Shared guidelines live under `plugin/skills/_shared/` and are loaded lazily by skills.

## Shared guideline packs

- `_shared/sdd_artifacts/`
  - `STORAGE.md`: manifest v2, storage resolution, naming, and path rules
  - `PIPELINE.md`: stage order, write confirmation rules, and missing-artifact dialogs
  - `SESSION.md`: session-state file schema and gate enforcement
- `_shared/caveman/CAVEMAN.md`
  - Compression levels (`lite`/`full`/`ultra`), Auto-Clarity, participation caps
- `_shared/caveman/COMPACT.md`
  - Optional CONTINUITY / memory narrative compact (validators + `sim`)
- `_shared/agents/RECEIPT.md`
  - Forma C specialist receipt schema when caveman is ON
- `_shared/dotnet_guidelines/`
  - Clean architecture, C# patterns, formatting, checklist
- `_shared/code_guidelines/`
  - Language-agnostic engineering principles (SOLID/DRY/KISS/YAGNI)
- `_shared/{python,javascript,react,angular}_guidelines/`
  - Stack-specific coding guidance for non-.NET repositories

## Guardrail and KI relationship

- Guardrails are authored in `GUARDRAILS.md`.
- `sync-antigravity.ps1` writes KI summaries into:
  - `knowledge/custom_skills`
  - `knowledge/global_guardrails`
- KI injection is what makes these rules consistently visible at conversation start.

## Language split

- Chat responses: `pt-BR`
- Skill and guideline files: English
- Code/tests/identifiers: English
- SDD artifacts: default `pt-BR`, English only by explicit user override

## Naming conventions

- Skill folders and skill command docs: underscore names (`sdd_spec`, `breakdown_tasks`)
- PRD file: `NNN_short_slug.md`
- PLAN file: `PLAN_NNN_short_slug.md`
- Feature tree: `features/NNN-slug/[USnn|TSnn]/{PRD,PLAN}/...` (+ FEATURE.md / CONTINUITY.md for Forma C)

## Validation scripts tied to shared rules

Primary smoke test:

```powershell
.\scripts\validation\validate-all.ps1
```

| Script | Purpose |
|--------|---------|
| `validate-all.ps1` | Orchestrator — run after every sync |
| `validate-skills-structure.ps1` | STOP gate, frontmatter, Forma C artifacts, manifest v2 |
| `validate-docs-consistency.ps1` | Naming and obsolete phrases |
| `validate-skills-english.ps1` | Skill body language heuristic |
| `validate-session-gates.ps1` | Session gate status (opt-in: `-IncludeSessionGate`) |
