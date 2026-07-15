# Install and Validate

## Prerequisites

- Windows with PowerShell 5.1+
- Antigravity IDE installed (to provision `~/.gemini`)

## Deploy plugin

From repository root:

```powershell
.\scripts\sync-antigravity.ps1
```

This deploy is idempotent and syncs:
- `plugin.json`
- `GUARDRAILS.md`
- all skills under `plugin/skills/`
- KI entries `custom_skills` and `global_guardrails`
- sessions folder for session-state gates

## Post-deploy validation

Run the unified smoke test from repository root:

```powershell
.\scripts\validation\validate-all.ps1
```

This orchestrates, in order:

| Check | Script |
|-------|--------|
| Deploy + KIs | `validate-toolkit-deploy.ps1` |
| Skills structure (STOP, frontmatter, Forma C artifacts) | `validate-skills-structure.ps1` |
| Docs consistency | `validate-docs-consistency.ps1` |
| Skills English | `validate-skills-english.ps1` |
| Impeccable / Blip / frontend | dedicated validators |

Optional flags:

| Flag | When to use |
|------|-------------|
| `-IncludeSessionGate -RepoPath <path>` | Verify session gate after user confirmed an action |
| `-RequiredGate <name>` | Gate name when using `-IncludeSessionGate` (default: `write_confirmed`) |
| `-FailFast` | Stop on first failing check |
| `-Quiet` | Summary table only |

Restart Antigravity IDE after a successful smoke test.

## Configure Classic SDD for a consumer repo

```powershell
.\scripts\configure-repo-sdd.ps1 -StorageMode repository -RepoPath "D:\Source\Repos\MyApp"
```

Or use storage mode `global` (artifacts under `~/.gemini/antigravity-ide/sdd/<repo>/features/`).

This writes manifest schema v2 with a `classic` section only. Legacy `speckit` keys in older manifests are ignored.

## Runtime gate validation helpers

```powershell
.\scripts\validation\validate-session-gates.ps1 -RepoPath "D:\Source\Repos\MyApp" -RequiredGate write_confirmed
```

## Language and naming reminder

- Chat policy: `pt-BR`
- Code/tests/skills docs: English
- Skill commands in docs: underscore naming (`breakdown_tasks`, not `breakdown-tasks`)
- Canonical SDD paths: `features/NNN-slug/` (not root `PRD/` / `PLAN/`)
