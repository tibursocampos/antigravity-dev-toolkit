# Guide 06: Specialized Developer Skills

This guide covers:
- `refactor`
- `api_integrate`
- `performance_profile`
- `containerize`
- `i18n_manager`

## Common execution pattern

1. Analyze the target surface.
2. Present findings.
3. Choose execution path:
   - direct with `developer`
   - full classic SDD (`sdd_spec` → `sdd_plan` → `sdd_develop`)
   - Spec Kit flow (`speckit_spec` → `speckit_plan` → `speckit_develop`)

## Skill snapshots

- `refactor`: identify complexity smells and apply safe incremental improvements.
- `api_integrate`: generate strongly-typed clients from OpenAPI/Swagger.
- `performance_profile`: baseline, optimize, and compare runtime paths.
- `containerize`: produce production-ready Docker assets.
- `i18n_manager`: extract literals and replace with localization key usage.

## Safety rules

- Use underscore names in invocation and docs.
- Preserve confirmation gates and tests before completion.
- Escalate to structured SDD when scope exceeds direct implementation.
