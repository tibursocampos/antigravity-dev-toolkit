# Guide 02: `developer`

Use the generic `developer` skill for focused tasks that do not require full SDD artifact generation. The skill **routes silently** to a stack-specific skill when the workspace matches a known stack.

## Example

`use skill developer — fix null pointer in OrderService when order has no items`

## Router behavior

`developer` inspects the workspace and delegates to the first matching stack skill (see [08-stack-developers.md](08-stack-developers.md)):

- New Blip plugin scaffold -> `blip_plugin_developer`
- Existing Blip plugin (`blip-ds`) -> `react_developer`
- Blazor, Electron, Vue, React Native / Expo, React, Angular, Node, .NET, Python -> matching `*_developer`

If no stack matches, `developer` implements directly (HTML, shell scripts, ad-hoc automation).

## Frontend design routing

Before UI implementation:

1. Net-new UI without `PRODUCT.md` -> recommend `use skill impeccable init` (new session).
2. `docs/DESIGN-BRIEF.md` exists -> delegate to matching `*_developer` without redesign.
3. One session = `impeccable shape` **or** implementation, not both.

See [impeccable-integration.md](../impeccable-integration.md).

## Expected behavior

1. Validate branch and repository context.
2. Read only required guidelines.
3. Propose minimal steps.
4. Implement with existing architecture patterns.
5. Run local tests/build.
6. Suggest `use skill commit` for approved commit flow.

## Escalation path

Escalate to classic SDD when complexity grows:

`use skill sdd_spec` -> `use skill sdd_plan` -> `use skill sdd_develop`

## Guardrail reminder

- No mutating git without explicit `sim`.
- Keep chat in `pt-BR`, implementation artifacts in English.
