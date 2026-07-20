# Scripts and Toolkit Orchestration

The `scripts/` directory contains the automation, validation, and local synchronization ecosystem for the Antigravity Developer Toolkit. These scripts are crucial for maintaining guardrails, testing behavior, and setting up environments properly.

## Core Orchestrator: `toolkit.ps1`

`scripts/toolkit.ps1` is the central orchestrator script for the repository. It is designed to be run locally by maintainers and CI to ensure changes adhere to the repository's constraints.

### Key Capabilities
- **Synchronization**: Automatically calls `sync-antigravity.ps1` to deploy local skills to the Antigravity AppData folder.
- **Validation**: Acts as a test suite runner. It invokes the validation scripts to guarantee that structural integrity, documentation consistency, and language constraints are met before any code is considered stable.
- **Maintainer Suite**: Exposes utility functions intended for maintainers of the toolkit rather than regular developers.
- **Validation and backup submenu** (`[7]`): run `validate-all` or individual validators (`skill-contracts`, `skill-graph`, `skill-fixtures`, `docs-consistency`), list sync backups, and restore a previous backup by `BackupId`.

## The Sync Process: `sync-antigravity.ps1`

Because the toolkit uses standard Antigravity configuration paths to load Knowledge Items (KIs) and Custom Skills, the local `plugin/` directory must be mapped/copied to the correct location.

- **Purpose**: Copies files from `plugin/skills` and KI sources to `~/.gemini/config/skills/` (Global Customizations Root) and `~/.gemini/knowledge/`.
- **Global Guardrails**: The script is responsible for injecting the `global_guardrails` KI, which is Layer 2 of our enforcement stack.

## Validation Suite

The `scripts/validation/` folder houses focused modules invoked by `validate-all.ps1`:

1. **`validate-all.ps1`** — post-sync smoke orchestrator
2. **`validate-toolkit-deploy.ps1`** — deploy paths after sync
3. **`validate-skills-structure.ps1`** — frontmatter, STOP gates, underscore names
4. **`validate-docs-consistency.ps1`** — catalog parity; forbids sibling toolkit refs and GitHub CLI
5. **`validate-skills-english.ps1`** — English skill bodies
6. **`validate-skill-contracts.ps1`** — markers from `contracts/skill-contracts.json`
7. **`validate-skill-graph.ps1`** — edges + forbid rules + skill counts
8. **`validate-skill-fixtures.ps1`** — golden `fixtures/<skill>/expected-markers.txt`
9. **`validate-session-gates.ps1`** — optional consumer session gates (`-IncludeSessionGate`)

### Adding a contract or fixture

1. Edit `scripts/validation/contracts/skill-contracts.json` or `skill-graph.json`.
2. Add `scripts/validation/fixtures/<skill>/expected-markers.txt` (one required substring per line).

## Backup and rollback

`sync-antigravity.ps1` creates a timestamped backup under `~/.gemini/antigravity-ide/sdd/toolkit-backups/<yyyyMMdd-HHmmss>/` before overwrite.

```powershell
.\scripts\restore-toolkit-backup.ps1
.\scripts\restore-toolkit-backup.ps1 -BackupId 20260720-091500
```

## Utility Scripts

- **`configure-repo-sdd.ps1`**: Configures the local repository (creates `manifest.json` classic entries) for SDD / Forma C storage.
- **`scripts/inventory/Invoke-MemoryBankInventory.ps1`**: Memory-bank inventory helper used by Forma C Step 0.
- **`uninstall-toolkit.ps1`**: Reverses the effects of the sync script, cleaning up the Antigravity AppData folder.
- **`restore-toolkit-backup.ps1`**: Restores a previous sync backup.
