# Guide 06: Specialized Developer Skills

This guide covers specialized implementation tools and workflow utilities.

**Stack-Specific Developer Skills**:
- `angular_developer`
- `react_developer`
- `python_developer`
- `javascript_developer`
- `dotnet_developer`

**Engineering Utilities**:
- `refactor`
- `api_integrate`
- `performance_profile`
- `containerize`
- `i18n_manager`

## Stack-Specific Development

For targeted coding tasks within a known tech stack, use the stack-specific developer skills (e.g., `angular_developer`) instead of the generic `developer` skill. These skills are pre-configured with stack-specific best practices, architectural knowledge, and linting rules.

## Common execution pattern (Utilities)

1. Analyze the target surface.
2. Present findings.
3. Choose execution path:
   - direct with `developer` (or a stack-specific skill)
   - full classic SDD (`sdd_spec` → `sdd_plan` → `sdd_develop`)
   - Spec Kit flow (`speckit_spec` → `speckit_plan` → `speckit_develop`)

## Utility snapshots

- `refactor`: identify complexity smells and apply safe incremental improvements.
- `api_integrate`: generate strongly-typed clients from OpenAPI/Swagger.
- `performance_profile`: baseline, optimize, and compare runtime paths.
- `containerize`: produce production-ready Docker assets.
- `i18n_manager`: extract literals and replace with localization key usage.

## Safety rules

- Use underscore names in invocation and docs.
- Preserve confirmation gates and tests before completion.
- Escalate to structured SDD when scope exceeds direct implementation.
