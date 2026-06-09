# Antigravity Dev Toolkit Overview

## Repository Purpose
The `antigravity-dev-toolkit` is a personal Antigravity IDE (Google DeepMind) agent toolkit. It provides a Software-Driven Development (SDD) workflow, .NET guidelines, and a Git-only developer flow without relying on corporate trackers or pipeline integrations.

## Architecture and Layout
- **`plugin/`**: Contains the core plugin manifest (`plugin.json`) and the individual skills used by the Antigravity IDE. It is deployed to `~/.gemini/antigravity-ide/plugins/<id>/`.
  - **`plugin/skills/`**: The bounded contexts of the toolkit, containing specific skills like `dev_persona`, `spec`, `plan`, `implement`, `code_review`, `commit`, `dotnet_developer`, `fix_build`, `test_coverage`, `plan_repo_docs`, and `document_repo`.
  - **`plugin/skills/_shared/`**: Contains shared guidelines (`dotnet_guidelines`, `code_guidelines`, `sdd_artifacts`) utilized across different skills.
- **`scripts/`**: Contains deployment scripts, primarily `sync-antigravity.ps1`, which is an idempotent script used to deploy the toolkit to the local Antigravity IDE plugins directory.
- **`docs/`**: Documentation folder containing installation guides, skills catalog, and further technical documentation.

## Integrations
- **Antigravity IDE**: Integrates as a native plugin.
- **Git**: Enforces a Git-only flow for branching and commits.

## Technical Stack
- **Documentation**: Markdown
- **Scripts**: PowerShell
- **Configuration**: JSON
