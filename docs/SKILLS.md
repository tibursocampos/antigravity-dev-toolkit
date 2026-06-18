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

Workflow alternativo ao SDD clássico, baseado na estrutura `.specify/` da CLI oficial do [GitHub Spec Kit](https://github.com/github/spec-kit). Ambos os fluxos (clássico e Spec Kit) suportam armazenamento local (no repositório) ou global (via manifest `~/.gemini/antigravity-ide/sdd/manifest.json`).

**Fluxo encadeado:** `speckit_setup` → `speckit_init` → `speckit_spec` → `speckit_plan` → `speckit_develop`

- **`speckit_setup`**: Verifica e instala pré-requisitos (Python 3.10+, `uv`, `specify-cli`) e configura o diretório global de SDD. Gatilhos: `setup speckit`, `/speckit_setup`.
- **`speckit_init`**: Inicializa a estrutura `.specify/` no repositório ativo (local ou global), gerando `constitution.md` via CLI. Gatilhos: `inicializar speckit`, `/speckit_init`.
- **`speckit_spec`**: Cria `spec.md` na estrutura `.specify/specs/NNN-<slug>/`, com numeração automática e template oficial. Gatilhos: `nova spec`, `criar spec speckit`, `/speckit_spec`.
- **`speckit_plan`**: Gera `plan.md` (design técnico) e `tasks.md` (checklist atômico de 20–45 min por tarefa) a partir de uma `spec.md`. Carrega `constitution.md` para respeitar restrições do projeto. Gatilhos: `planejar speckit`, `/speckit_plan`.
- **`speckit_develop`**: Executa a próxima tarefa pendente do `tasks.md`, implementa código em inglês, roda testes e atualiza o checklist. Sugere conventional commit ao final. Gatilhos: `executar tarefa speckit`, `/speckit_develop`.
