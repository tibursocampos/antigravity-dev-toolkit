# Guide 02: `developer`

Use the generic `developer` skill for focused tasks that do not require full SDD artifact generation, especially when working in environments without a dedicated specialized skill.

> **Note**: If you are working in a known stack that has a dedicated skill (e.g., `angular_developer`, `react_developer`, `dotnet_developer`, `python_developer`, `javascript_developer`), use that specialized skill instead. They contain tailored best practices and architectural guardrails.

## Example

`use skill developer — fix null pointer in OrderService when order has no items`

## Expected behavior

1. Validate branch and repository context.
2. Read only required guidelines (e.g., `_shared/dotnet_guidelines` if applicable).
3. Propose minimal steps.
4. Implement with existing architecture patterns.
5. Run local tests/build.
6. Suggest `use skill commit` for approved commit flow.

## Escalation path

Escalate to classic SDD when complexity grows:

`use skill sdd_spec` → `use skill sdd_plan` → `use skill sdd_develop`

## Guardrail reminder

- No mutating git without explicit `sim`.
- Keep chat in `pt-BR`, implementation artifacts in English.
