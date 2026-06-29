# Skills Catalog

This document lists the full toolkit catalog using underscore skill names for invocation.

## Installed skills (29)

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
11. `angular_developer` — Focused coding task for Angular.
12. `dotnet_developer` — Focused coding task for .NET.
13. `javascript_developer` — Focused coding task for Node.js/JS.
14. `python_developer` — Focused coding task for Python.
15. `react_developer` — Focused coding task for React.
16. `code_review` — Diff/branch review with severity and decision.
17. `fix_build` — Diagnose and repair local build/test failures.
18. `test_coverage` — .NET coverage report and threshold check.
19. `commit` — Conventional commit flow with confirmation gates.
20. `push` — Safe push flow.
21. `document_plan` — Create docs plan for repository context.
22. `document_implement` — Execute one docs-plan step.
23. `refine_backlog_item` — Refine backlog intake into structured markdown.
24. `breakdown_tasks` — Split refined backlog into grouped implementation checklist.
25. `refactor` — Safe, incremental refactoring.
26. `api_integrate` — Generate API client integration artifacts.
27. `performance_profile` — Profile and optimize hot paths.
28. `containerize` — Generate Docker/Docker Compose scaffolding.
29. `i18n_manager` — Extract and refactor localization literals.

## Compatibility aliases (2)

30. `plan_repo_docs` — Migration alias to `document_plan`.
31. `document_repo` — Migration alias to `document_implement`.

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
