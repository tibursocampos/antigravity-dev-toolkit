# Software-Driven Development (SDD) Workflow

The Antigravity Dev Toolkit utilizes a structured Software-Driven Development (SDD) process comprised of three core skills: `spec`, `plan`, and `implement`. This workflow ensures changes are thoroughly defined and planned before execution, avoiding "cowboy coding" and maintaining high-quality outputs.

## SDD Skills

### 1. `spec` (Requirements & PRD)
- **Trigger**: `use skill spec`, `create spec`, `new feature`
- **Purpose**: Answers the *what* and *why* of a feature. Gathers requirements, expected behavior, and technical constraints without jumping into implementation details.
- **Output**: A Product Requirements Document (PRD).

### 2. `plan` (Technical Planning)
- **Trigger**: `use skill plan`, `create plan`, `execution plan`
- **Purpose**: Takes a finalized PRD and translates it into a step-by-step technical execution plan. Each step is scoped to take roughly 20-45 minutes and represents a single chunk of work.
- **Output**: An Execution PLAN document.

### 3. `implement` (Execution)
- **Trigger**: `use skill implement`, `implement step`
- **Purpose**: Executes exactly *one* step from a generated PLAN per session. It writes production code and tests (always in English) and updates the PLAN document's progress. It avoids doing multiple steps in a single session to prevent context exhaustion.

## SDD Artifacts and Storage Locations

Both PRD and PLAN artifacts are stored directly within the consumer repository. The default prose language for these SDD artifacts is **Brazilian Portuguese (pt-BR)** unless explicitly overridden by the user. Identifiers and code references within these documents remain in English.

### Product Requirements Document (PRD)
- **Location**: `/PRD/` or `/docs/PRD/` at the repository root.
- **Naming Convention**: `NNN_short_feature_slug.md` (e.g., `001_user_login.md`), where `NNN` is an auto-incrementing 3-digit number.

### Execution Plan (PLAN)
- **Location**: `/PLAN/` or `/docs/PLAN/` at the repository root.
- **Naming Convention**: `PLAN_NNN_short_feature_slug.md` (e.g., `PLAN_001_user_login.md`), ensuring the prefix number exactly matches its source PRD.

All four of these directories (`/PRD/`, `/PLAN/`, `/docs/PRD/`, `/docs/PLAN/`) must be explicitly ignored in the consumer repository's `.gitignore` to prevent committing incomplete agent working files to the remote repository.
