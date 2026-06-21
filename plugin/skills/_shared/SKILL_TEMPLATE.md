# Skill template - gate-first header

Copy the block below immediately after YAML frontmatter in every `SKILL.md`.

Skill body (process, guardrails, handoff) must be **English**. User-facing prompts: **Ask user (pt-BR):** …

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

## Skill-specific sections (below the header)

- **Trigger**
- **Outcome**
- **Lazy-load**
- **Process**
- **Must not**
- **Handoff**

### Develop skills - mandatory session end

```
### STOP - Session end (mandatory)
- Show git diff summary
- Show test results (if applicable)
- Update PLAN/tasks/plan.md
- Reset session-state gates to false
- Ask user (pt-BR): "Passo concluído. Inicie nova conversa para o próximo passo."
- DO NOT proceed to next step
```
