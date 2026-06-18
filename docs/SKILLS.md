# Skills Catalog

This toolkit adds the following skills to the Antigravity IDE:

## Core SDD (Software-Driven Development)
- **`dev_persona`**: Main router and developer persona. Applies global language rules (pt-BR in artifacts) and workflow. Always active as a root directive.
- **`sdd_spec`**: Phase 1. Transforms ideas and requirements into a PRD (Product Requirements Document).
- **`sdd_plan`**: Phase 2. Transforms a PRD into a step-by-step implementation PLAN.
- **`sdd_develop`**: Phase 3. Executes atomic steps from a PLAN, writing code and ensuring tests and compliance.

## Development Skills
- **`code_review`**: Analyzes a diff or branch against requirements and best practices (SOLID, DRY, KISS, Guidelines).
- **`commit`**: Generates commit messages in the Conventional Commits standard and applies strict branch validations. Has an option to call `push` afterwards.
- **`push`**: Executes `git push` on the current branch.
- **`developer`**: Rapid C#/.NET development without the full SDD cycle. Follows Clean Architecture and tests based on xUnit/NUnit, Moq/NSubstitute, and Shouldly.

## Setup and Operational Skills
- **`fix_build`**: Resolves breaking build/test issues in the current workspace.
- **`test_coverage`**: Executes test coverage in .NET using Coverlet and ReportGenerator, returning metrics based on the target threshold.
- **`document_plan`**: Creates an iterative (RAG-oriented) documentation plan in a consuming repository.
- **`document_implement`**: Executes a pending step from the documentation plan, creating technical Markdown files.

---

## Spec Kit (GitHub Spec Kit Integration)

Alternative workflow to classic SDD, based on the `.specify/` structure of the official [GitHub Spec Kit](https://github.com/github/spec-kit) CLI. Both workflows (classic and Spec Kit) support local storage (in the repository) or global storage (via manifest `~/.gemini/antigravity-ide/sdd/manifest.json`).

**Chained flow:** `speckit_setup` → `speckit_init` → `speckit_spec` → `speckit_plan` → `speckit_develop`

- **`speckit_setup`**: Verifies and installs prerequisites (Python 3.10+, `uv`, `specify-cli`) and configures the global SDD directory. Triggers: `setup speckit`, `/speckit_setup`.
- **`speckit_init`**: Initializes the `.specify/` structure in the active repository (local or global), generating `constitution.md` via the CLI. Triggers: `initialize speckit`, `/speckit_init`.
- **`speckit_spec`**: Creates `spec.md` in the `.specify/specs/NNN-<slug>/spec.md` structure, with automatic numbering and the official template. Triggers: `new spec`, `create spec speckit`, `/speckit_spec`.
- **`speckit_plan`**: Generates `plan.md` (technical design) and `tasks.md` (atomic checklist of 20–45 min per task) from a `spec.md`. Loads `constitution.md` to respect project constraints. Triggers: `plan speckit`, `/speckit_plan`.
- **`speckit_develop`**: Executes the next pending task in `tasks.md`, implements code in English, runs tests, and updates the checklist. Suggests a conventional commit at the end. Triggers: `execute task speckit`, `/speckit_develop`.

---

## Caveman Mode Support

Most skills in this toolkit support **Caveman Mode**, which automatically compresses agent responses to save tokens and speed up interactions without omitting code or critical gates.

- **Toggle**: Use chat commands `caveman on` and `caveman off`.
- **Reference**: Detailed behavior rules can be found in [docs/guides/05-caveman-mode.md](guides/05-caveman-mode.md).
