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
.\scripts\validate-all.ps1
```

This orchestrates, in order:

| Check | Script |
|-------|--------|
| Deploy + KIs | `validate-toolkit-deploy.ps1` |
| Skills structure (STOP, frontmatter, artifacts) | `validate-skills-structure.ps1` |
| Docs consistency | `validate-docs-consistency.ps1` |
| Skills English | `validate-skills-english.ps1` |

Optional flags:

| Flag | When to use |
|------|-------------|
| `-IncludeSpeckit -RepoPath <path>` | Consumer repo has a valid `.specify/` tree |
| `-IncludeSessionGate -RepoPath <path>` | Verify session gate after user confirmed an action |
| `-RequiredGate <name>` | Gate name when using `-IncludeSessionGate` (default: `write_confirmed`) |
| `-FailFast` | Stop on first failing check |
| `-Quiet` | Summary table only |

Restart Antigravity IDE after a successful smoke test.

## Optional Spec Kit bootstrap

```powershell
.\scripts\setup-speckit.ps1
```

Then configure one repository:

```powershell
.\scripts\configure-repo-sdd.ps1 -StorageMode global -RepoPath "D:\Source\Repos\MyApp"
```

This writes manifest schema v2 entries:
- `classic` storage config
- `speckit` storage config + init validation metadata

## Runtime gate validation helpers

- Session gates:

```powershell
.\scripts\validate-session-gates.ps1 -RepoPath "D:\Source\Repos\MyApp" -RequiredGate write_confirmed
```

- Spec Kit init:

```powershell
.\scripts\validate-speckit-init.ps1 -RepoPath "D:\Source\Repos\MyApp"
```

## Language and naming reminder

- Chat policy: `pt-BR`
- Code/tests/skills docs: English
- Skill commands in docs: underscore naming (`breakdown_tasks`, not `breakdown-tasks`)
