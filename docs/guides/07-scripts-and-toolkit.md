# Scripts and Toolkit Orchestration

The `scripts/` directory contains the automation, validation, and local synchronization ecosystem for the Antigravity Developer Toolkit. These scripts are crucial for maintaining guardrails, testing behavior, and setting up environments properly.

## Core Orchestrator: `toolkit.ps1`

`scripts/toolkit.ps1` is the central orchestrator script for the repository. It is designed to be run locally by maintainers and CI to ensure changes adhere to the repository's constraints.

### Key Capabilities
- **Synchronization**: Automatically calls `sync-antigravity.ps1` to deploy local skills to the Antigravity AppData folder.
- **Validation**: Acts as a test suite runner. It invokes the validation scripts to guarantee that structural integrity, documentation consistency, and language constraints are met before any code is considered stable.
- **Maintainer Suite**: Exposes utility functions intended for maintainers of the toolkit rather than regular developers.

## The Sync Process: `sync-antigravity.ps1`

Because the toolkit uses standard Antigravity configuration paths to load Knowledge Items (KIs) and Custom Skills, the local `plugin/` directory must be mapped/copied to the correct location.

- **Purpose**: Copies files from `plugin/skills` and KI sources to `~/.gemini/config/skills/` (Global Customizations Root) and `~/.gemini/knowledge/`.
- **Global Guardrails**: The script is responsible for injecting the `global_guardrails` KI, which is Layer 2 of our enforcement stack.

## Validation Suite

The `scripts/validation/` folder houses several focused validation modules invoked by the orchestrator (or directly via `validate-all.ps1`). They ensure that changes do not violate the repository's architectural principles.

1. **`validate-all.ps1`**: The post-sync smoke test. Runs the full suite of deploy, structure, docs, and language checks.
2. **`validate-toolkit-deploy.ps1`**: Verifies that `sync-antigravity.ps1` successfully placed files in the correct target paths.
3. **`validate-skills-structure.ps1`**: Ensures all skills in `plugin/skills` have a valid `SKILL.md` with required frontmatter and follow the underscore naming convention.
4. **`validate-docs-consistency.ps1`**: Verifies that the catalog in `docs/SKILLS.md` matches the actual physical folders in `plugin/skills/`.
5. **`validate-skills-english.ps1`**: Enforces the language policy by scanning skill bodies (excluding prompts) for English adherence.
6. **`validate-session-gates.ps1`**: Validates the presence of `SESSION.md` gate checks logic in skill instructions.
7. **`validate-session-gates.ps1`**: Optional gate status check for a consumer repo (`-IncludeSessionGate`).

## Utility Scripts

- **`configure-repo-sdd.ps1`**: Configures the local repository (creates `manifest.json` classic entries) for SDD / Forma C storage.
- **`scripts/inventory/Invoke-MemoryBankInventory.ps1`**: Memory-bank inventory helper used by Forma C Step 0.
- **`uninstall-toolkit.ps1`**: Reverses the effects of the sync script, cleaning up the Antigravity AppData folder.
