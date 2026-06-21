# Skills Catalog

This document lists the full toolkit catalog using underscore skill names for invocation.

## Installed skills (24)

1. `dev_persona` — Router, language policy, workflow policy, and global guidance.
2. `sdd_spec` — Build PRD artifact for classic SDD.
3. `sdd_plan` — Build PLAN from canonical PRD.
4. `sdd_develop` — Execute exactly one PLAN step.
5. `speckit_setup` — Install Spec Kit prerequisites.
6. `speckit_init` — Initialize `.specify/` and validate constitution.
7. `speckit_spec` — Create `spec.md` under `.specify/specs/`.
8. `speckit_plan` — Generate `plan.md` and `tasks.md`.
9. `speckit_develop` — Execute one Spec Kit task.
10. `developer` — Focused coding task without full SDD.
11. `code_review` — Diff/branch review with severity and decision.
12. `fix_build` — Diagnose and repair local build/test failures.
13. `test_coverage` — .NET coverage report and threshold check.
14. `commit` — Conventional commit flow with confirmation gates.
15. `push` — Safe push flow.
16. `document_plan` — Create docs plan for repository context.
17. `document_implement` — Execute one docs-plan step.
18. `refine_backlog_item` — Refine backlog intake into structured markdown.
19. `breakdown_tasks` — Split refined backlog into grouped implementation checklist.
20. `refactor` — Safe, incremental refactoring.
21. `api_integrate` — Generate API client integration artifacts.
22. `performance_profile` — Profile and optimize hot paths.
23. `containerize` — Generate Docker/Docker Compose scaffolding.
24. `i18n_manager` — Extract and refactor localization literals.

## Compatibility aliases (2)

25. `plan_repo_docs` — Migration alias to `document_plan`.
26. `document_repo` — Migration alias to `document_implement`.

These aliases are documented for migration/handoff continuity; the installed folders remain `document_plan` and `document_implement`.

## Global rules across all skills

- Read `GUARDRAILS.md` and `SESSION.md` before mutating operations.
- Enforce gate-first behavior on every skill.
- Use manifest schema v2 for classic/speckit storage resolution.
- Keep chat in `pt-BR`; keep code and skill source in English.
- Never skip confirmation gates under Caveman mode.

## Related guides

- [sdd-workflow.md](sdd-workflow.md)
- [operational-developer-skills.md](operational-developer-skills.md)
- [guides/06-developer-skills.md](guides/06-developer-skills.md)
