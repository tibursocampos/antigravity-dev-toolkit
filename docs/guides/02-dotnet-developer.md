# .NET Development (`dotnet_developer`)

For minor fixes, targeted refactoring, or short technical tasks (less than 4 hours, touching few files), you can skip the full SDD cycle and use the direct .NET development skill.

## Usage example
`use skill dotnet_developer — fix null pointer in OrderService when order has no items`

## What the agent will do:
1. Analyze the repository (`*.sln`) and the existing folder structure.
2. Ask you to create/checkout a valid branch (`feature/` or `feat/`) if you aren't already on one.
3. Propose micro-steps in the chat itself to organize the changes.
4. Modify the code strictly following the patterns defined in `_shared/dotnet_guidelines/`:
   - Clean Architecture
   - FluentValidation
   - xUnit/NUnit + Moq/NSubstitute + Shouldly for the testing stack
   - Strict formatting rules in `csharp-patterns.md` (e.g., one type per file, correctly wrapped method signatures, prohibition of magic strings and replacement with PascalCase consts).
5. Execute local build and tests via `dotnet test` and validate success.
6. Suggest using the commit skill (`use skill commit`) to confirm the changes.

## When NOT to use
If the feature is cross-cutting and spans multiple dense layers (UI + Backend + Database + Messaging), if it involves large EF Core migrations, or if there is significant business ambiguity/complexity in the requirements, the agent (guided by the `dev_persona`) will interrupt you and recommend the `spec` and `plan` flow.
