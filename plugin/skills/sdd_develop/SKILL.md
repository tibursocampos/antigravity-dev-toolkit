---
name: sdd_develop
description: >
  Execute one PLAN baby step. Code always in English; updates PLAN .md in the file's
  language (pt-BR default). Use when the user says "use skill sdd_develop", "implement step",
  "/sdd_develop". One session = one PLAN step.
---

# Skill: sdd_develop

## Trigger

Invoke when the user asks for: `use skill sdd_develop`, `implement step`, `execute step`, or `/sdd_develop`.

## Outcome

One **PLAN step** done: **code and tests in English**; PLAN updated in place. Do not start the next step in the same session.

## Language

| Deliverable | Language |
|-------------|----------|
| Código, testes, comentários, XML docs | **English** |
| Progresso/notas do PLAN | **Mesmo idioma do arquivo PLAN** |
| Product `docs/` / README | Perguntar pt-BR vs English primeiro |

Não re-perguntar sobre storage SDD ou alterar idioma do artefato no meio do PLAN, exceto se solicitado.

## Required input

| Input | Regra |
|-------|-------|
| Path do PLAN | Canônico: `PLAN/PLAN_NNN_*.md` |
| Passo | `Step 1`, `PASSO 1`, etc. |

## Lazy-load (only when needed)

| When | Path |
|------|------|
| Pipeline, diálogo de PLAN ausente | `_shared/sdd_artifacts/PIPELINE.md` |
| Storage | `_shared/sdd_artifacts/STORAGE.md` |
| .NET, Git, contexto | `_shared/dotnet_guidelines/*.md`, `dev_persona` § Git, § Contexto |

## Process

### -1. Pipeline e modo

Carregar `PIPELINE.md`. **Agent** necessário para mudanças de código e atualizações de PLAN. Se o usuário pedir PRD/`sdd_spec` ou PLAN/`sdd_plan` → guiar per § Missing artifacts; não criar PRD/PLAN aqui.

### 0. Workspace

Repositório alvo. Resolver PLAN:

| Situação | Ação |
|----------|------|
| Path canônico do PLAN fornecido | `Read` no path exato |
| Nenhum PLAN canônico | `PIPELINE.md` § `sdd_develop` without PLAN (opções 1–3) |
| Usuário pede "criar PRD/plan" | Redirecionar para `sdd_spec` / `sdd_plan`; parar |

Detectar stack pelo passo do PLAN.

### 1. Validar passo

Passo existe; dependências **Concluídas**; resumir objetivo, arquivos, testes; pedir para prosseguir.

### 2. Git

Branch de feature per `dev_persona` § Branch validation.

### 3–4. Analisar e implementar

Glob/Grep/Read escopo. Código/testes em English; build/test direcionado.

### 5. Commit (opcional)

Oferecer `use skill commit`; não auto-commitar.

### 6. Atualizar PLAN + checkpoint

Marcar passo como concluído, progresso, próximo passo. Salvar antes de pausa de contexto (≥40%).

### 7. Reportar

Arquivos, testes, `N/M` (pt-BR). Handoff: nova conversa → `use skill sdd_develop — <full-plan-path> — Step N+1`.

## Must not

- Código de aplicação em português; múltiplos passos por sessão
- Criar PRD/PLAN; pular salvamento do PLAN; modificar `.gitignore`
- Implementar sem os arquivos de controle persistidos

## Handoff

| Situação | Próximo |
|----------|---------|
| Commit | `use skill commit` |
| Próximo passo | Nova sessão → `sdd_develop — <plan> — Step N+1` |
| Todos os passos concluídos | `use skill code_review` (opcional) |
