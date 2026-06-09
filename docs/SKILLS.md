# Skills Catalog

This toolkit adds the following skills to the Antigravity IDE:

## Core SDD (Software-Driven Development)
- **`dev_persona`**: Main router and developer persona. Applies global language rules (pt-BR in artifacts) and workflow. Always active as a root directive.
- **`spec`**: Phase 1. Transforms ideas and requirements into a PRD (Product Requirements Document).
- **`plan`**: Phase 2. Transforms a PRD into a step-by-step implementation PLAN.
- **`implement`**: Phase 3. Executes atomic steps from a PLAN, writing code and ensuring tests and compliance.

## Development Skills
- **`code_review`**: Analyzes a diff or branch against requirements and best practices (SOLID, DRY, KISS, Guidelines).
- **`commit`**: Generates commit messages in the Conventional Commits standard and applies strict branch validations.
- **`dotnet_developer`**: Rapid C#/.NET development without the full SDD cycle. Follows Clean Architecture and tests based on xUnit/NUnit, Moq/NSubstitute, and Shouldly.

## Setup and Operational Skills
- **`fix_build`**: Resolves breaking build/test issues in the current workspace.
- **`test_coverage`**: Executes test coverage in .NET using Coverlet and ReportGenerator, returning metrics based on the target threshold.
- **`plan_repo_docs`**: Creates an iterative (RAG-oriented) documentation plan in a consuming repository.
- **`document_repo`**: Executes a pending step from the documentation plan, creating technical Markdown files.
