# Operational and Developer Skills

The Antigravity Dev Toolkit provides a suite of operational and developer-focused skills that handle isolated tasks, validation, and source control operations outside the strict bounds of the SDD feature planning process.

## Developer Skills

### `developer`
- **Purpose**: Implement or fix small-to-medium features without needing a full SDD PRD/PLAN cycle.
- **Workflow**: Operates directly on the codebase using Clean Architecture and the specified testing stack. It checkpoints frequently but is intended for isolated tasks under ~4 hours. If scope expands, it recommends escalating to the full `sdd_spec` → `sdd_plan` → `sdd_develop` SDD flow.

## Operational & Validation Skills

### `code_review`
- **Purpose**: Reviews a diff or branch against the PRD/PLAN acceptance criteria, project standards, and Clean Architecture principles.
- **Output**: Generates a structured report with severity tiers (critical, important, nice-to-have) and a clear decision (Approved, Approved with caveats, or Changes required).

### `fix_build`
- **Purpose**: Diagnoses and fixes failing .NET build or test runs locally.
- **Workflow**: Reads local `dotnet build` or `dotnet test` output (or a pasted log), analyzes root causes, and proposes structural fixes. It will wait for user confirmation before applying fixes to the codebase.

### `test_coverage`
- **Purpose**: Runs .NET test coverage and evaluates it against a predefined threshold (default is 80%).
- **Workflow**: Uses `coverlet.collector` and `reportgenerator` to compute coverage specifically on *new code* (changed production `.cs` files) compared to the base branch. It generates comprehensive HTML and text summaries in the `TestResults/` folder.

### `commit`
- **Purpose**: Manages Git state by reviewing changes, ensuring branch validity, and drafting Conventional Commits.
- **Workflow**: Validates that the branch follows the `feature/<slug>` or `feat/<id>` convention. It drafts a commit message (`type(scope): description`) and explicitly waits for user approval before staging (`git add`) and committing. It enforces a strict Git-only flow without requiring Azure DevOps or other corporate trackers. After a successful commit, it will suggest using the `push` skill.

### `push`
- **Purpose**: Sends the committed changes to the remote repository.
- **Workflow**: Pushes the current branch upstream and sets up tracking if needed. Explicitly avoids force pushing to main integration branches.

### `refactor`
- **Purpose**: Identify code smells (cognitive complexity, long methods) and safely refactor structures.
- **Workflow**: Performs static analysis, presents a checklist of debt, and prompts the user to select an execution workflow. Performs safe step-by-step code transformations, verifying against compiler and test runners at each iteration.

### `api-integrate`
- **Purpose**: Scaffold strongly typed client integrations from OpenAPI schemas.
- **Workflow**: Parses Swagger/OpenAPI files, details operations, and asks the user for the workflow path. Generates client configurations, endpoints, and request/response models.

### `performance-profile`
- **Purpose**: Profile and optimize runtime code or query paths.
- **Workflow**: Audits code for SQL/LINQ bottlenecks, scaffolds micro-benchmarks (like BenchmarkDotNet), compares execution speed, and optimizes.

### `containerize`
- **Purpose**: Dockerize projects for production and development.
- **Workflow**: Scans the tech stack, proposes multi-stage Dockerfiles and compose dependencies, and builds clean settings templates.

### `i18n-manager`
- **Purpose**: Internationalize and localize code variables.
- **Workflow**: Extracts hardcoded string literals into resource dictionaries (RESX or JSON) and rewrites files to use dynamic locale lookup.

## Expected Testing Stack
All .NET skills in the toolkit strictly adhere to the following testing stack philosophies and tools:
- **Test Framework**: `xUnit` (default) or `NUnit`
- **Mocking**: `Moq` (default) or `NSubstitute`
- **Assertions**: `Shouldly` is the prioritized assertion library for new tests.
- **Data Generation**: The use of `Bogus`, `Fake` and similar tools is explicitly permitted and encouraged for test data setup.
- **Strategy**: Integration Tests are prioritized over Unit Tests wherever feasible.
- **Naming Convention**: `Should_<Result>_When_<Condition>`
