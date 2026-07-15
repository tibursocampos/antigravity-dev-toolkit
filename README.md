# antigravity-dev-toolkit

Personal Antigravity IDE plugin toolkit for disciplined software execution: gate-first skills, SDD Formas A/B/C (`features/NNN-slug/`), strong guardrails, and Git-only workflows.

## Highlights

- **Formas A / B / C**: Classic SDD, backlog prep, and orchestrated multi-story (memory-bank + `orchestrate_*`).
- **Manifest v2**: classic storage (`repository` or `global`) from `manifest.json` under `~/.gemini/antigravity-ide/sdd/`.
- **Validation scripts**: unified smoke test (`validate-all.ps1`) plus deploy, docs, structure, language, and optional session-gate checks.
- **Enforcement without native hooks**: `GUARDRAILS.md` + KI injection + SESSION gates.

## Quick start

```powershell
.\scripts\sync-antigravity.ps1
.\scripts\validation\validate-all.ps1
```

Interactive menu:

```powershell
.\scripts\toolkit.ps1
```

Register a consumer repo for Classic SDD:

```powershell
.\scripts\configure-repo-sdd.ps1 -StorageMode repository -RepoPath "D:\Source\Repos\MyApp"
```

Optional session-gate check:

```powershell
.\scripts\validation\validate-all.ps1 -IncludeSessionGate -RepoPath "D:\Source\Repos\MyApp"
```

## Workflows

| Forma | Pipeline |
|-------|----------|
| **A** Classic | `sdd_spec` -> `sdd_plan` -> `sdd_develop` |
| **B** Backlog | `refine_backlog_item` -> `breakdown_tasks` -> A or C |
| **C** Orchestrated | Step 0 `memory_bank_init` -> `orchestrate_analyze` -> `orchestrate_deliver` -> `orchestrate_develop` \| `sdd_develop` |

Canonical artifact root: `features/NNN-slug/` (see `plugin/skills/_shared/sdd_artifacts/STORAGE.md`).

**Breaking:** Spec Kit (`speckit_*`) and root flat `PRD/` / `PLAN/` flows are removed. Migrate to Formas A/C.

## Docs

- [AGENTS.md](AGENTS.md) — guardrails contract
- [docs/SKILLS.md](docs/SKILLS.md) — skill catalog
- [docs/guides/](docs/guides/) — user guides (incl. Forma C 10–12)
- [docs/INSTALL.md](docs/INSTALL.md) — install / sync
- [docs/ENFORCEMENT.md](docs/ENFORCEMENT.md) — enforcement model
- [docs/SYNC_POLICY.md](docs/SYNC_POLICY.md) — sync with cursor-dev-toolkit

## Contributor notes

1. Chat replies: pt-BR. Skill sources and production code: English.
2. Skill folders use underscores (`sdd_spec`).
3. Respect one-step-per-session in `sdd_develop`, Forma C O3, and `document_implement`.
4. Never auto-run mutating git; confirm with `sim`.
