---
name: speckit-spec
description: >
  Cria uma nova especificação técnica (spec.md) sob a estrutura do Spec Kit.
  Use para criar especificação do speckit, nova spec, ou /speckit_spec.
---

# Skill: speckit_spec

## Trigger

Invoke when the user asks for: `use skill speckit_spec`, `criar spec speckit`, `nova spec`, or `/speckit_spec`.

## Outcome

A complete `spec.md` in **pt-BR** written to `.specify/specs/NNN-<slug>/spec.md` at the resolved destination (local or global). Mandatory input for `speckit_plan`.

## Spec boundaries

The spec answers **what** and **why**, not **how**. No implementation code. Identifiers (types, APIs, paths) in **English**.

## Lazy-load (only when needed)

| When | Path |
|------|------|
| Storage resolution and manifest | `_shared/sdd_artifacts/STORAGE.md` § Global Manifest and Dynamic Storage Resolution |
| Path validation and confirm gate | `_shared/sdd_artifacts/PIPELINE.md` § Spec Kit path validation |

## Process

### -1. Pipeline and storage

Load `STORAGE.md` § Resolution algorithm and `PIPELINE.md` § Spec Kit path validation. No `Write` without explicit **sim** from the user.

### 0. Workspace

Confirm the target repository. Read `.specify/memory/constitution.md` if it exists (project rules and preferences).

### 1. Determine next NNN

```
List: {destination}/.specify/specs/*/
Count existing folders.
NNN = (highest existing index) + 1, zero-padded to 3 digits (e.g., 001, 007, 042).
If no folder exists: NNN = 001.
```

### 2. Collect requirements

**Prior context** in chat (requirements, code, review): produce a structured summary + at most **3** gap questions — skip the full questionnaire.

**Otherwise**, ask the user (pt-BR):

```
Vou criar a spec. Informe:
1) Feature — o que construir ou alterar?
2) Comportamento atual
3) Comportamento esperado
4) Contexto adicional (opcional)
```

Wait for answers before proceeding.

### 3. Generate slug and path

```
slug = <title in ASCII kebab-case, max 40 characters>
path = {destination}/.specify/specs/NNN-{slug}/spec.md
```

### 4. Draft the spec

Produce `spec.md` in pt-BR following the official Spec Kit template:

```markdown
# NNN — <Título da Feature>

## Contexto e Motivação
<Por que esta feature é necessária?>

## Comportamento Atual
<O que acontece hoje?>

## Comportamento Esperado
<O que deve acontecer após a implementação?>

## Critérios de Aceitação
- [ ] <critério 1>
- [ ] <critério 2>

## Fora do Escopo
<O que explicitamente não será feito>

## Riscos e Considerações
<Riscos técnicos ou de negócio>

## Status
Pronto para planejamento
```

### 5. Confirm before write

Show: title, `NNN`, **absolute path**, storage mode, content bullets.
Ask the user (pt-BR): **"Posso gravar em `{path}`? (sim / ajustar / cancelar)"**

### 6. Write (after sim)

1. Validate path per `PIPELINE.md` § Spec Kit path validation regex — abort if invalid.
2. Create folder `{destination}/.specify/specs/NNN-{slug}/` if it does not exist.
3. `Write` to `spec.md`.
4. Report: written path, NNN, storage mode.

## Must not

- Write without explicit user confirmation (**sim**)
- Use a path outside the `.specify/specs/NNN-<slug>/` structure
- Include implementation code in the spec
- Create `plan.md` or `tasks.md` in this session

## Handoff

```
use skill speckit_plan — {written path}
```
