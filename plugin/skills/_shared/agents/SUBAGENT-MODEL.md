# Specialist pass model policy (Forma C)

Contract for **how** `orchestrate_analyze`, `orchestrate_deliver`, and `orchestrate_develop` run specialist work in Antigravity. Orthogonal to **when** to run a specialist (`ROSTER.md`) and to Memory Bank Gate policy `auto` (bank health).

Install path after sync: `{pluginRoot}/skills/_shared/agents/SUBAGENT-MODEL.md`

Antigravity has **no** Cursor `Task` / hooks equivalent. Forma C uses:

1. **Serial specialist passes** in the parent chat (load `prompts/*.md`, run that role to completion, update CONTINUITY).
2. **Optional handoff chats** — parent prepares a prompt; user opens a new conversation for isolation (O3 one PLAN step per session).
3. Parent orchestrator **never** writes application code in bulk.

## Default (almost every specialist pass)

1. Run the specialist **in the current chat model** (user’s Antigravity selection).
2. Do **not** ask the user about model choice for routine work.
3. Do **not** pick premium / alternate models on your own.

## Rare premium gate

Ask about a different model **only** when the upcoming pass is clearly very hard. Prefer **not** asking.

### Threshold (narrow)

Ask only if **at least two** signals match, **or** one obvious hard-stop:

| Signal | Examples |
|--------|----------|
| O1 | `complexity=complex` **and** two or more specialists (e.g. `architect` + `security`), or deep brownfield impact |
| O2 | Story with ambiguous contracts/auth/schema and high risk of a wrong PRD |
| O3 | PLAN step = cross-cutting architecture, destructive migration, sensitive security, or a hermetic bug that already failed on default |
| User | User already marked the work **crítico** / asked for maximum quality |

### Do **not** ask for

Simple STORY draft, ordinary PRD/PLAN, CRUD, wiring, mechanical tests, CONTINUITY-only updates, single low-ambiguity specialists.

### Prompt (pt-BR) — only when the gate fires

```text
Antes do passe especialista `{role}` nesta tarefa difícil:
motivo: {1-2 frases}
Sugiro trocar para um modelo mais capaz (custa mais).

1) sim - trocar modelo e continuar
2) não - seguir no modelo atual (padrão)
3) cancelar passe
```

| Answer | Action |
|--------|--------|
| **sim** | Wait for user to switch model, then continue that pass |
| **não** / silence | Continue on current model (RN01: silence ≠ premium approval) |
| **cancelar** | Do not run the pass |

## Must not

- Switch models without this gate **and** explicit user **sim**
- Ask the model question on every pass
- Treat silence as approval to use premium
- Confuse Memory Bank policy `auto` with Auto model selection
- Spawn parallel app-code writers; O3 = **one** `sdd_develop` step per session

## Serial batches

Run specialists one after another. Prefer CONTINUITY checkpoints between passes. Never mark multiple PLAN develop steps done in one session.
