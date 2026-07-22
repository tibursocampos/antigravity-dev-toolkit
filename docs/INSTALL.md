# Install and Validate

> **Repository policy:** public — clone and fork freely. **No upstream contributions** (do not open PRs here). See [CONTRIBUTING.md](../CONTRIBUTING.md).

## Prerequisites

| Requirement | Notes |
|-------------|--------|
| **Antigravity IDE** | Provisions `~/.gemini` |
| **PowerShell** | Windows: **5.1+** or **pwsh 7+**. macOS/Linux: **pwsh 7+** required |

## Deploy plugin

**Recommended:** interactive toolkit CLI:

```powershell
# Windows
.\scripts\toolkit.ps1
```

```bash
# macOS / Linux (pwsh required)
chmod +x scripts/*.sh scripts/validation/*.sh
./scripts/toolkit.sh
```

Direct sync from repository root:

```powershell
.\scripts\sync-antigravity.ps1
```

```bash
./scripts/sync-antigravity.sh
```

This deploy is idempotent and syncs:
- `plugin.json`
- `GUARDRAILS.md`
- all skills under `plugin/skills/`
- KI entries `custom_skills` and `global_guardrails`
- `~/.gemini/config/skills.json` (plugin skills path)
- managed block in `~/.gemini/config/AGENTS.md` (sandbox + skill discovery rules)
- sessions folder for session-state gates
- migration away from legacy folder `Local.raphadev.antigravity-dev-toolkit`

Install path: `~/.gemini/antigravity-ide/plugins/antigravity-dev-toolkit/`.

## Post-deploy validation

Run the unified smoke test from repository root:

```powershell
.\scripts\validation\validate-all.ps1
```

This orchestrates, in order:

| Check | Script |
|-------|--------|
| Deploy + KIs + config AGENTS/skills.json | `validate-toolkit-deploy.ps1` |
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

## Initial configuration (Antigravity chat)

1. Restart Antigravity IDE after sync.
2. Smoke-test skill discovery:

> What skills from antigravity-dev-toolkit are installed? List a few skill folder names.

**Pass:** real skill folder names from the global plugin path.  
**Fail:** sandboxed `view_file` on `skills.json`, or skills not found.

If it fails, paste these `/learn` commands **one at a time**, then retry the smoke test (see also [README.md](../README.md#initial-configuration)):

```text
/learn Whenever you need to read restricted files under .gemini/config (such as skills.json), use the terminal tool run_command with Get-Content (Windows) or cat (Mac/Linux), because direct access via view_file is blocked by the system sandbox.

/learn On the first turn of a conversation, before answering about available skills or running a skill, read ~/.gemini/config/skills.json via Get-Content or cat, then resolve each entries[].path to discover installed skills.

/learn Toolkit skills live only under the global plugin folder ~/.gemini/antigravity-ide/plugins/antigravity-dev-toolkit/skills/. Never search for SKILL.md in the current workspace or repository.

/learn After resolving the skills path, read GUARDRAILS.md and skills/dev_persona/SKILL.md from that global plugin folder before any mutating action.

/learn When the user says use skill [name] or /[name], open SKILL.md at <plugin>/skills/[name]/SKILL.md (underscore folder names) before acting.
```

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
- Skill commands in docs: underscore naming (`split_story_checklist`, not `split-story-checklist`)
- Canonical SDD paths: `features/NNN-slug/` (not root `PRD/` / `PLAN/`)
