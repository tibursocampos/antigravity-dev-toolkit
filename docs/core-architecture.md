# Core Plugin Architecture

## Plugin Manifest
The Antigravity Dev Toolkit operates as a native Antigravity IDE plugin. The core of this integration is the `plugin.json` manifest located in the `plugin/` directory.

- **Name**: `antigravity-dev-toolkit`
- **Description**: Defines the toolkit's purpose, including its SDD workflow, .NET guidelines, and Git-only flow without external corporate trackers.
- **State**: Enabled by default (`"disabled": false`).

## Skills and Auto-Discovery
Skills within the toolkit are organized under `plugin/skills/`. Each skill directory contains a `SKILL.md` file.

The Antigravity IDE automatically discovers and loads skills by parsing the `description` field in the frontmatter of each `SKILL.md` file. When the user writes a natural language prompt, the IDE matches the prompt to these descriptions to activate the corresponding skill logic.

## Deployment Process
The deployment of the toolkit is handled by a PowerShell script: `scripts/sync-antigravity.ps1`.

### Sync Mechanism
1. **Target Directory**: The script discovers the IDE's plugins directory. It primarily checks `%APPDATA%\antigravity-ide\plugins\` and falls back to `%LOCALAPPDATA%\Google\antigravity-ide\plugins\`. The target folder for this plugin is `Local.raphadev.antigravity-dev-toolkit`.
2. **Idempotent Copy**: It synchronizes `plugin.json` and the entire `skills/` directory tree. It uses SHA-256 hash comparisons (`Get-FileHash`) to ensure files are only copied if they have been modified.
3. **Knowledge Item (KI) Sync**: It also generates and writes a `metadata.json` under `%USERPROFILE%\.gemini\antigravity-ide\knowledge\custom_skills` to explicitly instruct the IDE agent to read `SKILL.md` files before executing skills.
4. **Non-Destructive**: The script is non-destructive. It does not delete other existing plugins in the target directory and offers a `-DryRun` parameter for testing.

After running the sync script, restarting the Antigravity IDE is required to load any new or updated skills into memory.
