# antigravity-dev-toolkit

Personal Antigravity IDE plugin toolkit for disciplined software execution: gate-first skills, SDD (classic + Spec Kit), strong guardrails, and Git-only workflows.

## What improved

- **Enforcement stack**: `plugin/GUARDRAILS.md` + `global_guardrails` KI + session-state gates in `~/.gemini/antigravity-ide/sdd/sessions/`.
- **Gate-first execution**: every skill starts with Step -1 checks before Write/Shell and before mutating git.
- **Manifest v2**: classic and speckit storage are resolved independently (`repository` or `global`) from `manifest.json`.
- **Validation scripts**: unified smoke test (`validate-all.ps1`) plus individual deploy, docs, structure, language, session gates, and Spec Kit init validators.
- **Naming consistency**: skill folder names use underscores (for example `refine_backlog_item`, `breakdown_tasks`).

## Important behavior

- `dev_persona` is not magic always-on by itself.
- Always-on behavior is achieved by the `global_guardrails` knowledge item written by `scripts/sync-antigravity.ps1`.
- Chat language is `pt-BR`; code, tests, and skill source documents remain in English.

## Quick start

1. Clone this repository.
1. Run:

For an interactive menu to deploy, validate, or maintain the toolkit, run:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/toolkit.ps1
```

Or you can run the sync script directly:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/sync-antigravity.ps1
```

1. Restart Antigravity IDE.
1. Run the post-sync smoke test:

```powershell
.\scripts\validate-all.ps1
```

Optional flags:

```powershell
.\scripts\validate-all.ps1 -IncludeSpeckit -RepoPath "D:\Source\Repos\MyApp"
.\scripts\validate-all.ps1 -IncludeSessionGate -RepoPath "D:\Source\Repos\MyApp"
```

Individual validators still work in isolation when debugging one check.

## Repository map

- `plugin/plugin.json`: plugin manifest.
- `plugin/GUARDRAILS.md`: non-negotiable hard rules.
- `plugin/skills/*/SKILL.md`: skill contracts.
- `plugin/skills/_shared/`: shared guidelines and SDD artifacts.
- `docs/`: operator and maintainer documentation.
- `scripts/`: interactive orchestrator (`toolkit.ps1`) and deployment automation.
  - `validation/`: test suite.
  - `maintainers/`: internal utils.

## Skills

The toolkit documents **26 skill entries**:

- **24 installed skill folders** in `plugin/skills/`.
- **2 migration aliases** kept in docs for compatibility handoffs.

See full catalog in [docs/SKILLS.md](docs/SKILLS.md).

## Guardrails first

Before any mutating operation, the agent must:

1. Read `GUARDRAILS.md`.
2. Read and resolve `SESSION.md` for the current workspace.
3. Verify user confirmation (`sim`) for the current action.
4. Respect one-step-per-session in `sdd_develop`, `speckit_develop`, and `document_implement`.

## Related docs

- [docs/INSTALL.md](docs/INSTALL.md)
- [docs/core-architecture.md](docs/core-architecture.md)
- [docs/sdd-workflow.md](docs/sdd-workflow.md)
- [docs/shared-guidelines.md](docs/shared-guidelines.md)
- [docs/guides/README.md](docs/guides/README.md)
