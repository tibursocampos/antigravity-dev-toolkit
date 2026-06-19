# Antigravity Dev Toolkit Overview

## Repository Purpose
The `antigravity-dev-toolkit` is a personal Antigravity IDE (Google DeepMind) agent toolkit. It provides a Software-Driven Development (SDD) workflow, .NET guidelines, and a Git-only developer flow without relying on corporate trackers or pipeline integrations.

## Architecture and Layout
- **`plugin/`**: Contains the core plugin manifest (`plugin.json`) and the individual skills used by the Antigravity IDE. It is deployed to `~/.gemini/antigravity-ide/plugins/<id>/`.
  - **`plugin/skills/`**: The bounded contexts of the toolkit, containing specific skills like `dev_persona`, `sdd_spec`, `sdd_plan`, `sdd_develop`, `speckit_setup`, `speckit_init`, `speckit_spec`, `speckit_plan`, `speckit_develop`, `code_review`, `commit`, `push`, `developer`, `fix_build`, `test_coverage`, `document_plan`, `document_implement`, `refactor`, `api_integrate`, `performance_profile`, `containerize`, and `i18n_manager`.
  - **`plugin/skills/_shared/`**: Contains shared guidelines (`dotnet_guidelines`, `code_guidelines`, `python_guidelines`, `javascript_guidelines`, `react_guidelines`, `angular_guidelines`, `sdd_artifacts`, `caveman`) utilized across different skills.
- **`scripts/`**: Contains deployment scripts, primarily `sync-antigravity.ps1`, which is an idempotent script used to deploy the toolkit to the local Antigravity IDE plugins directory.
- **`docs/`**: Documentation folder containing installation guides, skills catalog, and further technical documentation.

## Core Features
- **Software-Driven Development (SDD)**: Classic and Spec Kit workflows using markdown artifacts (`spec.md`, `plan.md`, `tasks.md`).
- **Caveman Response Compression**: An optional mode controlled by a global `preferences.json` to compress verbose conversational prose while keeping technical details and confirmation gates intact.


## Integrations
- **Antigravity IDE**: Integrates as a native plugin.
- **Git**: Enforces a Git-only flow for branching and commits.

## Technical Stack
- **Documentation**: Markdown
- **Scripts**: PowerShell
- **Configuration**: JSON
