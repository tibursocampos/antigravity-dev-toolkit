---
name: developer
description: >
  Implement or fix small-to-medium .NET features without full SDD. Uses Clean Architecture,
  xUnit/NUnit, Moq/NSubstitute, Shouldly, and Git-only developer flow. Use when the user says
  "use skill developer", "dotnet fix", or for isolated C# work. For larger cross-cutting
  features, route to sdd_spec -> sdd_plan -> sdd_develop.
---

## STOP - Read before ANY tool call

1. Read `{pluginRoot}/GUARDRAILS.md`
2. Read `_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`
3. If the relevant gate is not approved: **STOP** - ask user **(pt-BR)** â€” do **NOT** Write/Shell
4. SDD/develop skills: after **ONE** step/task, **STOP** session - handoff only
5. This skill body is **English**; user-facing prompts may be **(pt-BR)**

### Step -1 - Gate check (report in chat before continuing)

```
Gate check:
[ ] GUARDRAILS.md read
[ ] SESSION.md read; session-state loaded
[ ] PIPELINE.md read (SDD/speckit skills only)
[ ] User confirmed current action (sim)
â†’ If any unchecked: STOP
```

---

# Skill: developer

## Trigger

Use when user asks for `use skill developer`, `dotnet fix`, or a small isolated .NET implementation.

## Outcome

Working .NET code and tests in the target workspace, validated with build/tests, with optional handoff to `use skill commit`.

## When to escalate to SDD

Recommend `sdd_spec -> sdd_plan -> sdd_develop` if two or more apply:
- 3+ layers touched
- Schema/migration changes
- Cross-repo or cross-service impact
- New external integration
- 10+ files or 4h+ estimate
- Existing approved PLAN

## Lazy-load references

- Branch and commit rules: `dev_persona`
- .NET architecture: `_shared/dotnet_guidelines/clean-architecture.md`
- C# and testing style: `_shared/dotnet_guidelines/csharp-patterns.md`
- Final checklist: `_shared/dotnet_guidelines/checklist.md`
- Context policy: `dev_persona` context management
- Caveman rules (if active): `_shared/caveman/CAVEMAN.md`

Do not preload unrelated guideline trees.

## Process

### -1. Re-check guardrails and session

Confirm `GUARDRAILS.md` and `SESSION.md` were read and session-state is loaded.
If missing, ask user (pt-BR):

```text
Antes de continuar, confirme:
- GUARDRAILS.md lido
- SESSION.md carregado

Posso seguir? (sim / ajustar / cancelar)
```

### -2. Caveman mode

Check `~/.gemini/antigravity-ide/sdd/preferences.json`.
If Caveman is active, load `_shared/caveman/CAVEMAN.md` and notify user (pt-BR):

```text
Modo Caveman ativo (respostas compactas). Digite `caveman off` para desativar.
```

### 0. Workspace

Confirm target repo (`*.sln`/`*.csproj`), read `README.md`, summarize requested acceptance.

### 1. Guidelines

Load only required `.NET` guidelines and confirm stack: xUnit/NUnit + Moq/NSubstitute + Shouldly.

### 2. Branch

Use valid branch pattern (`feature/<slug>` or `feat/<id>`). Never commit on `main`/`master`/`develop`.

### 3. Micro-plan

Define 3-7 concrete tasks and checkpoint context usage after each major change.

### 4. Implement

Follow existing code patterns and clean architecture boundaries.

### 5. Tests

Add/update meaningful tests. Prefer integration tests when repository patterns support them.

### 6. Validate

```bash
dotnet build
dotnet test --no-build
```

### 7. Handoff

Offer `use skill commit`. Do not commit automatically.

## Must not

- Use corporate tracker APIs
- Use obsolete test stacks
- Work outside allowed branch patterns
- Add speculative scope outside acceptance
- Auto-commit or auto-PR

## Handoff

- Commit: `use skill commit`
- Review: `use skill code_review`
- Scope grew: `sdd_spec -> sdd_plan -> sdd_develop`
