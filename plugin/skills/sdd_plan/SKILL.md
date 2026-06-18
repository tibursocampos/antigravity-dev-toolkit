---
name: sdd_plan
description: >
  Create a baby-step PLAN from an existing PRD. Writes agent PLAN .md in pt-BR by default
  (in PLAN/ or docs/PLAN/ of the target repo). Use when the user says "use skill sdd_plan",
  "create plan", "/sdd_plan". Requires a PRD; output feeds sdd_develop.
---

# Skill: sdd_plan

## Trigger

Invoke when the user asks for: `use skill sdd_plan`, `create plan`, `execution plan`, or `/sdd_plan`.

## Outcome

A **PLAN** in **pt-BR** at a **canonical** path (`PLAN/PLAN_NNN_*.md`). Same `NNN` as PRD. Each step = one `sdd_develop` session. Paths and test names in **English**; no code blocks.

## Lazy-load (only when needed)

| When | Path |
|------|------|
| Pipeline guards, missing PRD dialog | `_shared/sdd_artifacts/PIPELINE.md` |
| Storage, manifest, `.gitignore` | `_shared/sdd_artifacts/STORAGE.md` |
| SDD language, context, .NET | `dev_persona` § Idioma, `_shared/dotnet_guidelines/*.md` |

## Process

### -1. Pipeline e modo

Carregar `STORAGE.md` e `PIPELINE.md`. Executar o algoritmo de resolução de armazenamento dinâmico (`STORAGE.md` § Resolution algorithm). Identificar `storage_mode` e `path` para o repositório ativo. Se for a primeira execução no repositório, executar o fluxo de seleção do modo de armazenamento e gravar no `manifest.json`.
Sem autoria de PRD; sem código de produção/testes.

### 0. Workspace

Repositório alvo. Ler `README.md` se presente.

### 1. Resolver PRD

Fazer glob de PRDs canônicos sob o diretório de destino resolvido (local ou global).

| Situação | Ação |
|----------|------|
| Usuário forneceu path canônico do PRD | `Read`; validar status **Pronto para planejamento** |
| Nenhum PRD canônico | Opções per `PIPELINE.md` § `sdd_plan` without PRD — criar PRD primeiro ou coletar texto/arquivo |
| "Criar PRD" | Handoff para `sdd_spec`; não gravar PLAN até PRD existir (exceto usuário escolher opção 2 explicitamente) |
| `.md` não canônico | Promover per `PIPELINE.md` ou pedir arquivo |

Resumir PRD; pedir para prosseguir.

### 2–4. Explorar, perguntas técnicas (≤10), baby steps

Glob/Grep/Read. Passos ~20–45 min cada. Passos de doc: **sdd_develop** pergunta idioma de documentação.

### 5. Checkpoint de contexto

Ver `dev_persona` § Gestão de Contexto; rascunho do PLAN em chat se ≥40%.

### 5.75. Confirmar antes de gravar

`PLAN_NNN_*`, path completo (resolvido sob o diretório do storage mode ativo), link do PRD, contagem de passos. **sim** obrigatório antes de `Write`.

### 6. Gravar PLAN (após sim)

1. Validar path per `PIPELINE.md` § Path validation helper — abortar se inválido.
2. Criar subpasta `PLAN/` no destino resolvido se não existir.
3. Gravar `PLAN_NNN_*` com `NNN` **igual** ao do PRD. Cabeçalho do PRD = path completo do PRD; passos **Pendente**; `0/N`.
4. Avisar se sobrescrevendo PLAN com passos concluídos.
5. Se `storage_mode` for `repository`, garantir os padrões no `.gitignore` conforme `STORAGE.md` § Repository mode — .gitignore.

### 7. Validar com o usuário

Apresentar passos, dependências, riscos. Confirmar primeiro passo de sdd_develop.

## Must not

- Gravar PLAN em inglês por padrão; embutir código de implementação
- Criar ou sobrescrever PRD; implementar ou commitar aqui
- Gravar PLAN sem PRD canônico (exceto escolha explícita do usuário — opção 2 com specs)
- Pular confirmação antes de gravar; afirmar PLAN salvo sem `Write`
- `NNN` diferente do PRD

## Handoff

```
use skill sdd_develop — <full-plan-path> — Step 1
```

Uma sessão = um passo do PLAN.
