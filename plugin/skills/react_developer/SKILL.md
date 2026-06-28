---
name: react-developer
description: >
  Implement or fix small-to-medium React features without full SDD. Uses React, functional components, hooks,
  TSX/JSX, Jest/React Testing Library, and Git-only developer flow. Use for isolated React work. 
  For larger cross-cutting features, route to sdd_spec -> sdd_plan -> sdd_develop.
---

## STOP - Read before ANY tool call

1. Read `{pluginRoot}/GUARDRAILS.md`
2. Read `_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`
3. If the relevant gate is not approved: **STOP** - ask user **(pt-BR)** - do **NOT** Write/Shell
4. SDD/develop skills: after **ONE** step/task, **STOP** session - handoff only
5. This skill body is **English**; user-facing prompts may be **(pt-BR)**

### Step -1 - Gate check (report in chat before continuing)

```
Gate check:
[ ] GUARDRAILS.md read
[ ] SESSION.md read; session-state loaded
[ ] PIPELINE.md read (SDD/speckit skills only)
[ ] User confirmed current action (sim)
-> If any unchecked: STOP
```

---

# Skill: react_developer

## Trigger

Use when user asks for `use skill react_developer`, `react fix`, or a small isolated React implementation.

## Outcome

Working React components and tests in the target workspace, validated with tests/build, with optional handoff to `use skill commit`.

## Lazy-load references

- Branch and commit rules: `dev_persona`
- React/Frontend guidelines: `_shared/react_guidelines/` and `_shared/frontend_guidelines/`
- General coding principles: `_shared/code_guidelines/principles/`
- Context policy: `dev_persona` context management
- Caveman rules (if active): `_shared/caveman/CAVEMAN.md`

Do not preload unrelated guideline trees.

## Process

Follow the same validation, branch, micro-plan, implement, tests (Jest/React Testing Library), and validate steps as standard developer flow. Focus on functional components, hooks, and clean React architecture.
