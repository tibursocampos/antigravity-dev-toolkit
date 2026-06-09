# Operational and Quality Skills

Operational skills help with routine maintenance tasks, reviews, and secondary tasks to the main development.

## 1. Code Review (`code_review`)
**Invocation:** `use skill code_review`

The agent evaluates the current branch or an explicit diff against the requirements of a PRD/PLAN or simply against global best practices (`_shared/code_guidelines` - SOLID, DRY, KISS, YAGNI, Encapsulation) and local stack guidelines. 
Returns a hierarchical report dividing into *blockers* and suggestions, plus an approval badge (Pass/Fail). It can generate a PR via `gh` (GitHub CLI) if requested.

## 2. Commit (`commit`)
**Invocation:** `use skill commit`

Reads the changes from the *working tree* (staged and unstaged), formats a proper commit message following the *Conventional Commits* standard (e.g., `feat(orders): add recalculation limit`), and commits it.
**Strict rule:** The agent will never perform an auto-commit without you first approving the message in the chat. It also enforces blocks against committing to forbidden branches (main, master).

## 3. Test Coverage (`test_coverage`)
**Invocation:** `use skill test_coverage`

Executes .NET test coverage locally (Coverlet + ReportGenerator) reporting detailed line percentage metrics in the chat, indicating whether the *recent changes* exceed the acceptable threshold (default 80%).

## 4. Fix Build (`fix_build`)
**Invocation:** `use skill fix_build`

If the build or any test breaks and you want a quick diagnosis. It will run `dotnet build/test` (or read logs pasted in the chat), diagnose the root cause (culture issue, assertion failure, introduced bug, package mismatch), suggest the fix, and apply the fix only if you approve, re-running the test to ensure stability.

## 5. RAG-based Documentation (`plan_repo_docs` and `document_repo`)
Essential when the Antigravity IDE is about to work on a new, unknown repository and needs rich textual context for Retrieval-Augmented Generation (RAG).

- `use skill plan_repo_docs`: Explores the repository, sets a target language for the product's technical documentation, writes a comprehensive `docs/overview.md`, and sets up an atomic documentation roadmap in `docs/documentation-plan/plan.md`.
- `use skill document_repo`: Runs as a standalone step to execute the next pending task mapped by the documentation plan created above.
