# Skills Catalog

This document lists the full toolkit catalog using underscore skill names for invocation.

## Installed skills (36)

1. `dev_persona` — Router, language policy, workflow policy, and global guidance.
2. `sdd_spec` — Build PRD artifact for classic SDD.
3. `sdd_plan` — Build PLAN from canonical PRD.
4. `sdd_develop` — Execute exactly one PLAN step.
5. `speckit_setup` — Install Spec Kit prerequisites.
6. `speckit_init` — Initialize `.specify/` and validate constitution.
7. `speckit_spec` — Create `spec.md` under `.specify/specs/`.
8. `speckit_plan` — Generate `plan.md` and `tasks.md`.
9. `speckit_develop` — Execute one Spec Kit task.
10. `developer` — Router: invokes the correct stack skill or fallback implementer.
11. `impeccable` — Frontend design router (upstream pbakaus/impeccable); produces DESIGN-BRIEF.
12. `angular_developer` — Focused coding task for Angular.
13. `blazor_developer` — Focused coding task for Blazor UI (WASM/Server/Hybrid).
14. `dotnet_developer` — Focused coding task for .NET.
15. `electron_developer` — Focused coding task for Electron desktop apps.
16. `javascript_developer` — Focused coding task for Node.js/JS.
17. `python_developer` — Focused coding task for Python.
18. `react_developer` — Focused coding task for React (incl. existing Blip plugins).
19. `vue_developer` — Focused coding task for Vue 3.
20. `blip_plugin_developer` — Scaffold new Blip React plugins (create-blip-extension).
21. `code_review` — Diff/branch review with severity and decision.
22. `fix_build` — Diagnose and repair local build/test failures.
23. `test_coverage` — .NET coverage report and threshold check.
24. `commit` — Conventional commit flow with confirmation gates.
25. `push` — Safe push flow.
26. `document_plan` — Create docs plan for repository context.
27. `document_implement` — Execute one docs-plan step.
28. `refine_backlog_item` — Refine backlog intake into structured markdown.
29. `breakdown_tasks` — Split refined backlog into grouped implementation checklist.
30. `refactor` — Safe, incremental refactoring.
31. `api_integrate` — Generate API client integration artifacts.
32. `performance_profile` — Profile and optimize hot paths.
33. `containerize` — Generate Docker/Docker Compose scaffolding.
34. `i18n_manager` — Extract and refactor localization literals.
35. `add_migrations` — EF Core migration discovery and add.
36. `create_message_consumer` — Message consumer scaffold (bus detected via Grep).

## Compatibility aliases (2)

37. `plan_repo_docs` — Migration alias to `document_plan`.
38. `document_repo` — Migration alias to `document_implement`.

These aliases are documented for migration/handoff continuity; the installed folders remain `document_plan` and `document_implement`.

## Frontend ecosystem

| Area | Skill / doc |
|------|-------------|
| Design | `impeccable` — [impeccable-integration.md](impeccable-integration.md) |
| Blip plugins | `blip_plugin_developer` — [blip-plugin-integration.md](blip-plugin-integration.md) |
| Stack developers | `react_developer`, `angular_developer`, `vue_developer`, `blazor_developer`, `electron_developer`, `javascript_developer` — [guides/08-stack-developers.md](guides/08-stack-developers.md) |

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
- [impeccable-integration.md](impeccable-integration.md)
- [blip-plugin-integration.md](blip-plugin-integration.md)
