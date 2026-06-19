---
name: api-integrate
description: >
  Generate strongly typed API integration clients and data models (DTOs) from OpenAPI/Swagger definitions.
  Use when the user says "use skill api-integrate", "integrate api", or "/api-integrate".
---

# Skill: api-integrate

## Trigger

Invoke when the user requests: `use skill api-integrate`, `integrate api`, `/api-integrate`, or asks to integrate endpoints from a schema.

**Arguments (optional):**

| Input | Meaning |
|-------|---------|
| Schema source | Path to local `openapi.json` / `swagger.yaml` or a remote metadata URL |
| Target service name | Specific name for the generated client class / wrapper |

## Outcome

A typed, modular, and robust API client containing:
1. Strongly typed DTO models (Request and Response contracts).
2. Clean service wrapper or client declarations using preferred libraries (e.g., Refit/HttpClient for C#, Axios/Fetch for TS/JS, HTTPX for Python).
3. Configured authentication headers, timeout limits, and robust network error wrappers.

## Lazy-load

| When | Path |
|------|------|
| C# projects | `_shared/dotnet_guidelines/clean-architecture.md`, `_shared/dotnet_guidelines/csharp-patterns.md` |
| JavaScript / TypeScript | `_shared/javascript_guidelines/clean-code-ts.md`, `_shared/javascript_guidelines/google-ts-style.md` |
| Python projects | `_shared/python_guidelines/google-style.md` |
| Caveman Mode (if active) | `_shared/caveman/CAVEMAN.md` — Full mode |

## Process

### -1. Caveman Mode Check
* Check `~/.gemini/antigravity-ide/sdd/preferences.json` and honor active compressions.

### 0. Detect Tech Stack and Locate Schema
* Identify target project language and preferred HTTP client patterns.
* Locate the OpenAPI spec (ask user or load the specified file path). Validate that the file is readable.

### 1. Plan Structure & Workflow Decision
* Propose the client layout:
  * Destination folder (e.g. `src/services/` or `Infrastructure/Clients/`).
  * File splits: client interface, models, configuration.
* Present the summary of identified API endpoints, routes, and request/response shapes.
* Stop and ask the user to choose the workflow execution path based on the integration scope:
  * **Option A - Direct Developer Skill (`use skill developer`):** For straightforward local client generation.
  * **Option B - Classic SDD (`use skill sdd_spec` -> `sdd_plan` -> `sdd_develop`):** For complex third-party integrations requiring formal specifications (PRD) and a detailed plan (PLAN) in Portuguese.
  * **Option C - Spec Kit (`use skill speckit_spec` -> `speckit_plan` -> `speckit_develop`):** For repositories initialized with Spec Kit.
  * **Option D - Plain Chat Plan:** Establish a simple task list directly in the chat, executing steps one by one without extra file creations.
* **Wait for explicit user choice** before writing code or initializing another workflow.

### 2. DTO and Model Generation
* Parse request/response components in the OpenAPI schema.
* Generate strictly typed models:
  * TypeScript: `export interface UserDto { ... }`
  * C#: `public record UserDto(int Id, string Name);`
  * Python: `from pydantic import BaseModel` dataclasses or standard models.

### 3. API Method Implementation
* Generate the client wrapper calling the endpoints.
* Include JSDoc / C# XML documentation on each method indicating summary, parameter descriptions, and return types from the schema.
* Set up standard header injection (Authorization Bearer, API Keys).

### 4. Robust Error Handling
* Add interceptors or try/catch blocks that convert HTTP 4xx/5xx responses into meaningful custom exception structures.
* Avoid general exception swallowing.

### 5. Validate & Compile
* Save generated files.
* Execute local compile tasks (`dotnet build`, `tsc --noEmit`, `mypy`) to verify zero type mismatches or syntax issues.
* Suggest writing integration tests.

### 6. Handoff
* Offer committing the new files:
  ```
  use skill commit
  ```

## Must not
* Generate generic `any` types for request/response payloads.
* Hardcode credentials, base URLs, or secret tokens. Fetch them from configuration environments.
