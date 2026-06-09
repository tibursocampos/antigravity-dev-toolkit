---
name: sdd_spec
description: >
  Create a PRD for a new feature or change. Writes agent PRD .md in pt-BR by default
  (in PRD/ or docs/PRD/ of the target repo). Use when the user says "use skill sdd_spec",
  "create spec", "new feature", or "/sdd_spec". Output feeds the sdd_plan skill.
---

# Skill: sdd_spec

## Trigger

Invoke when the user asks for: `use skill sdd_spec`, `create spec`, `new feature`, or `/sdd_spec`.

## Outcome

A complete **PRD** (agent `.md` artifact) in **Brazilian Portuguese (pt-BR)** at a **canonical** path (`PRD/`, `docs/PRD/`). English only if the user overrides in this invocation. Mandatory input for **sdd_plan**.

## PRD boundaries

The PRD answers **what**, not **how**. No implementation code. Identifiers (types, APIs, paths) in **English**.

## Lazy-load (only when needed)

| When | Path (after sync) |
|------|-------------------|
| Pipeline guards, modes, confirm, paths | `_shared/sdd_artifacts/PIPELINE.md` |
| Storage, manifest, `.gitignore` | `_shared/sdd_artifacts/STORAGE.md` |
| .NET / C# context | `_shared/dotnet_guidelines/clean-architecture.md`, `csharp-patterns.md` |

## Process

### -1. Pipeline e modo

Carregar `PIPELINE.md`. Confirmar antes de gravar — nenhum `Write` sem **sim** do usuário. Guard: sem PLAN, sem `Write` em `*.cs`, `*.csproj`, migrations.

### 0. Workspace

Repositório alvo (não `antigravity-dev-toolkit`, exceto se for o assunto). Ler `README.md`. Detectar stack. Fazer glob de PRDs existentes para determinar `NNN`.

### 1. Requisitos

**Contexto anterior** (chat, code-review, backlog): resumo estruturado + máximo **3** perguntas de lacuna — pular questionário completo.

**Caso contrário**, perguntar (pt-BR):

```
Vou criar o PRD. Informe:
1) Feature — o que construir ou alterar?
2) Comportamento atual
3) Comportamento esperado
4) Contexto adicional (opcional)
5) ID de rastreamento (opcional)
```

Aguardar respostas.

### 2–5. Confirmar repo, explorar código, clarificar (≤5), análise técnica

Confirmação de branch, Glob/Grep/Read, impacto e riscos breves para o PRD.

### 6. Checkpoint de contexto

Em ≥40%, rascunho em chat ou arquivo parcial; avisar antes de continuar. Ver `dev_persona` § Gestão de Contexto.

### 6.75. Confirmar antes de gravar

Título, `NNN`, **path canônico completo**, storage, bullets, status **Pronto para planejamento**. Aguardar **sim** / **ajustar** / **cancelar**.

### 7. Gravar PRD (após sim)

1. Validar path per `PIPELINE.md` § Path validation — abortar se não canônico.
2. `NNN_short_feature_slug.md`; corpo em pt-BR.
3. Product `docs/` em escopo: perguntar idioma de documentação primeiro.

Reportar path, idioma, mudanças em `.gitignore`. Handoff: `use skill sdd_plan — <full-prd-path>`.

## Must not

- PRD em inglês por padrão; código de implementação no PRD
- `Write` fora das pastas canônicas de PRD; pular confirmação antes de gravar
- `Write` em código de produção ou testes; criar PLAN nesta sessão
- Afirmar "PRD salvo" sem `Write` bem-sucedido
- Trackers externos; colar corpo completo de guidelines no PRD

## Handoff

```
use skill sdd_plan — <full-prd-path>
```
