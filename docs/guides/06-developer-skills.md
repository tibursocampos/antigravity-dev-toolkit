# Developer and Infrastructure Skills Guide

This guide describes the purpose, workflow, and execution pathways for the five specialized developer and infrastructure skills introduced in the toolkit: `refactor`, `api-integrate`, `performance-profile`, `containerize`, and `i18n-manager`.

---

## The Workflow Selection Paradigm

When running any of these skills, they do not immediately make blind changes to your codebase. Instead, they follow a standard **two-phase interaction flow**:

1. **Analysis Phase:** The skill scans your target files or configurations and presents a clear summary of what was found (e.g., code smells, API routes, performance bottlenecks, dependencies).
2. **Decision Phase:** The skill halts and prompts you to select one of the following execution paths depending on the task's scope:
   * **Option A - Direct Developer Skill (`use skill developer`):** For small, immediate, and localized changes.
   * **Option B - Classic SDD (`use skill sdd_spec` -> `sdd_plan` -> `sdd_develop`):** For larger or complex structural changes requiring formal specifications (PRDs) and step-by-step checklists (PLANs) written in Portuguese.
   * **Option C - Spec Kit (`use skill speckit_spec` -> `speckit_plan` -> `speckit_develop`):** For repositories configured with Spec Kit.
   * **Option D - Plain Chat Plan:** Establish a simple, direct checklist in the chat and implement the code step-by-step without generating extra tracking files.

---

## 1. Code Refactoring (`refactor`)

### Invocation
`use skill refactor` or `/refactor` (Optionally pass the file path or method name as arguments).

### Purpose
Examines your C#, Python, JavaScript/TypeScript, React, or Angular components for high cognitive complexity, long routines, or SOLID violations, and refactors them safely.

### How it works
* It reads the code and lists candidate smells (e.g., nesting above 3 levels, methods over 30 lines).
* It prompts you to select a workflow path.
* During implementation, it modifies the code incrementally, compiling and running your test suite (via `dotnet test`, `npm test`, or `pytest`) at each step. If a test fails, it immediately rolls back.

---

## 2. API Integration Client Generator (`api-integrate`)

### Invocation
`use skill api-integrate` or `/api-integrate` (Pass the path to your `openapi.json` or remote metadata URL).

### Purpose
Generates strongly typed HTTP integration clients, service contracts, and request/response DTO models directly from OpenAPI/Swagger specifications.

### How it works
* It parses the schema, lists the target routes/operations, and prompts you to select a workflow path.
* It generates structured directories separating the configuration, services, and models.
* It uses the preferred library for the repository's stack (e.g., Refit for C#, Axios/Fetch for TS/JS, HTTPX for Python).
* It verifies that the generated client compiles without type mismatches.

---

## 3. Performance Profiling and Optimization (`performance-profile`)

### Invocation
`use skill performance-profile` or `/performance-profile`.

### Purpose
Audits database access code (LINQ/SQL) and CPU/Memory alocations, configures local benchmarks, and safely optimizes execution paths.

### How it works
* It audits your code for performance anti-patterns (such as N+1 queries, boxing, or missing projections).
* It configures a micro-benchmark (e.g., BenchmarkDotNet class for C#, `timeit` for Python, `perf_hooks` for JS) and asks you to run it to capture baseline metrics.
* After choosing a workflow path, it implements the optimized variant and re-runs the benchmark to generate a before-and-after comparison table.

---

## 4. Containerization and Docker Scaffolding (`containerize`)

### Invocation
`use skill containerize` or `/containerize`.

### Purpose
Scaffolds optimized Docker configurations and multi-service development environments tailored to your repository.

### How it works
* It scans your workspace to detect the tech stack, port configurations, and dependent backing services (e.g. database, cache).
* It prompts you for a workflow path.
* It generates:
  * A multi-stage `Dockerfile` (optimized for size and utilizing non-root users).
  * A `.dockerignore` file.
  * A `docker-compose.yml` linking the application to its required local databases/caches with volume bindings.

---

## 5. Internationalization and Localization (`i18n-manager`)

### Invocation
`use skill i18n-manager` or `/i18n-manager`.

### Purpose
Extracts hardcoded UI strings, moves them to resource translation bundles, and refactors your codebase to load them dynamically.

### How it works
* It scans the target folders for string literals (filtering out log templates, system constants, and keys) and suggests translation keys.
* It prompts you for a workflow path.
* It appends the key-value mappings to the localization files (like `.resx` XML nodes or `en.json` / `pt.json` files).
* It refactors components to inject localizers and dynamically resolve keys (e.g. replacing `"Welcome"` with `t('Welcome')`).
