---
name: dev-persona
description: >
  Router central do toolkit pessoal de desenvolvimento. Ativa automaticamente para
  estabelecer idioma, convenções de Git, workflow SDD e catálogo de skills disponíveis.
  Substitui AGENTS.md e todas as rules do cursor-dev-toolkit. Invoque explicitamente
  com "use skill dev-persona" para ver o catálogo completo ou reforçar as convenções.
---

# dev-persona — Router Central

Router pessoal do `antigravity-dev-toolkit`. Este documento define **idioma**, **workflow**, **convenções Git**, **gestão de contexto** e o **catálogo de skills**. Aplica-se a toda interação enquanto o plugin estiver instalado.

---

## Idioma

| Contexto | Regra |
|----------|-------|
| Respostas ao usuário no chat | **Português brasileiro (pt-BR)** sempre |
| Artefatos SDD (`PRD/*.md`, `PLAN/PLAN_*.md`) | **pt-BR** por padrão; inglês somente se o usuário solicitar na mesma invocação |
| Código-fonte, testes, identificadores, XML docs | **English** sempre |
| Commits, títulos e corpo de PR | **English** sempre |
| `docs/`, README do projeto | Perguntar (pt-BR ou English) antes de gravar |
| Nomes de skills, paths, exemplos de comando | **English** |

**Termo técnico em pt-BR:** termos como `branch`, `PR`, `hook`, `skill`, `commit` permanecem em inglês quando comuns na prática de dev — não traduzir.

---

## Workflows

### SDD — Spec Driven Development

Use para complexidade média/alta: migrações, múltiplos componentes, design transversal ou escopo indefinido.

```
spec → plan → implement  (um passo do PLAN por sessão)
```

| Skill | Como invocar | Saída típica |
|-------|-------------|--------------|
| `spec` | "use skill spec" | `PRD/NNN_*.md` ou `docs/PRD/NNN_*.md` |
| `plan` | "use skill plan" | `PLAN/PLAN_NNN_*.md` |
| `implement` | "use skill implement" | Código + checkbox do passo do PLAN |

**Checkpoint:** uma sessão de `implement` = um passo do PLAN. Inicie nova conversa para o próximo passo.

**Guards do pipeline:** ordem canônica, confirmação antes de gravar, diálogos de PRD/PLAN ausentes — detalhes em `_shared/sdd_artifacts/PIPELINE.md`.

### Shortcut — trabalho .NET isolado

Para fixes pequenos, refactors simples ou baixa complexidade (área única, sem necessidade de PRD):

```
dotnet-developer
```

Invoke: "use skill dotnet-developer". Carrega `_shared/dotnet_guidelines/` sob demanda; dispensa SDD completo quando desnecessário.

### Fluxos opcionais (Git-only, sem work-item tracker)

| Fluxo | Passos |
|-------|--------|
| Documentação do repositório (RAG) | `plan-repo-docs` → `document-repo` (um passo por sessão) |
| Falha de build / testes | `fix-build` → `commit` opcional |
| Cobertura de testes .NET | `test-coverage` |
| Code review | `code-review` → handoff com `spec` se necessário |
| Commit convencional | `commit` |

---

## Pipeline SDD — Guards

### Ordem

`spec` → `plan` → `implement`. Não crie PLAN sem PRD canônico (exceto "PLAN direto" explícito do usuário). Não implemente sem PLAN canônico em disco.

### Paths canônicos

- **PRD:** `PRD/NNN_*.md`, `docs/PRD/NNN_*.md`
- **PLAN:** `PLAN/PLAN_NNN_*.md` (NNN coincide com o PRD)

Nunca salve artefatos SDD em `docs/backlog/` ou `docs/*.md` ad-hoc.

### Artefato ausente

Se PRD ou PLAN não existir, pergunte em **pt-BR** antes de handoff seco:

```
Não encontrei o PRD/PLAN canônico para esta feature.

Opções:
1) Criar PRD agora com "use skill spec"
2) Você fornece o spec/arquivo na próxima mensagem
3) Cancelar
```

### Confirmar antes de gravar

Para PRD ou PLAN **novos**: mostre o path completo + sumário e pergunte:

```
Posso gravar em `{path}`? (sim / ajustar / cancelar)
```

Grave apenas após **sim**.

### Limites de escopo

- `spec` / `plan`: sem alterações em código de produção ou testes.
- `code-review`: não grava PRD/PLAN; handoff de achados com `use skill spec`.

---

## Gestão de Contexto

> **Sem hooks no Antigravity IDE.** O monitoramento de contexto é feito manualmente: o agente avisa o usuário quando percebe respostas longas ou múltiplos passos consecutivos.

### Tabela de ação por uso de contexto

| Uso estimado | Status | Ação |
|-------------|--------|------|
| **< 40%** | OK | Continuar normalmente |
| **≥ 40%** | Aviso | Pausar skills multi-passo; salvar artefato de controle |
| **≥ 80%** | Crítico | Parar imediatamente; não aceitar "force continue" |

### Fluxo obrigatório ao final de cada passo multi-etapa

1. **Persistir progresso** — atualizar o arquivo de controle (checkbox, status, notas).
2. **Avaliar contexto** — estimar pelo comprimento da conversa ou perguntar ao usuário.
3. **Decidir** pela tabela acima.
4. Se **≥ 40%**, pausar e exibir:

```
EXECUÇÃO PAUSADA — Contexto estimado alto.

Isso é uma parada de segurança. A execução não continua automaticamente.

Salvo: [path do artefato de controle]
Último passo concluído: [id — descrição curta]
Próximo pendente: [id — descrição curta]

Recomendado: iniciar nova conversa e retomar pelo arquivo de controle.
Para continuar nesta sessão, responda: force continue
```

5. **Override do usuário:**
   - `force continue` → continuar; repetir checkpoint após próximo passo
   - Qualquer outra resposta → encerrar a skill; recomendar nova sessão
   - Se **≥ 80%**: não aceitar `force continue` — parar definitivamente

### O que não fazer

- Não continuar SDD multi-passo silenciosamente após 40% sem salvar e notificar
- Não encerrar uma skill abruptamente sem persistir o artefato de controle

---

## Convenções Git

### Conventional Commits

Todo `git commit` deve seguir [Conventional Commits](https://www.conventionalcommits.org/).

**Formato:**

```
<type>[escopo opcional][!]: <descrição>

[corpo opcional]

[footer(s) opcional(is)]
```

**Tipos válidos:**

| Tipo | Uso |
|------|-----|
| `feat` | Nova feature |
| `fix` | Correção de bug |
| `docs` | Documentação apenas |
| `style` | Formatação, sem mudança de lógica |
| `refactor` | Refactor sem fix ou feat |
| `perf` | Melhoria de performance |
| `test` | Adicionar ou corrigir testes |
| `build` | Build system ou dependências |
| `ci` | Configuração de CI/CD |
| `chore` | Manutenção sem impacto em código de produção |
| `revert` | Reverter commit anterior |

**Regras:**
- Subject line: descrição em lowercase, sem ponto final
- Use `!` após tipo/escopo para **BREAKING CHANGE**
- Separar corpo e footers do subject com linha em branco

**Nunca** atribuir o agente de IA como co-autor:
- Sem `Co-authored-by: Antigravity …` (ou variantes)
- Sem `--trailer` para atribuição de co-autoria

Footers permitidos: `Refs: #…`, `BREAKING CHANGE:`, `Fixes: #…` — por convenção do projeto apenas.

### Validação de Branch

Antes de qualquer `git add`, `git commit` ou `git push`, verificar o branch atual.

**Padrões permitidos:**

| Padrão | Exemplo |
|--------|---------|
| `feature/<slug>` | `feature/add-oauth-login` |
| `feat/<id>` | `feat/123`, `feat/issue-42` |

**Branches bloqueados:** `main`, `master`, `develop` e qualquer branch que não corresponda aos padrões acima.

Se bloqueado:
1. Escolher slug ou id para o trabalho
2. Criar e mudar para branch válido: `git checkout -b feature/<slug>`
3. Retomar o fluxo de commit

---

## Idioma dos Artefatos SDD (detalhe)

### Escopo

| Em escopo | Fora do escopo |
|-----------|----------------|
| `PRD/*.md`, `docs/PRD/*.md` | Código-fonte, testes, configs |
| `PLAN/PLAN_*.md` | Commit messages |
| Notas de progresso e checkboxes dentro dos PLANs | `docs/` do projeto, README, ADRs (perguntar) |

### Regras de escrita

- **Títulos de seção, labels de metadados, prosa, critérios de aceitação** (Dado/Quando/Então/E): **pt-BR**
- **Identificadores no texto** (nomes de tipo, método, rota de API, path de arquivo, nome de teste): **English**
- **Sem código de implementação** em PRDs/PLANs; se snippet ilustrativo for inevitável, sintaxe e identificadores em **English**

### Override para artefato em inglês

Aplicar apenas quando o usuário solicita explicitamente na **mesma** invocação:
- `em inglês`, `in english`, `english only`, `PRD em inglês`, `PLAN em inglês`

### Comportamento por skill

| Skill | Comportamento |
|-------|--------------|
| `spec` | Novo PRD → pt-BR (exceto override) |
| `plan` | Novo PLAN → pt-BR (exceto override); lê PRD existente em qualquer idioma |
| `implement` | Código → English; atualiza PLAN no **idioma do arquivo existente** |

---

## Catálogo de Skills

Instalado em `~/.gemini/antigravity-ide/plugins/Local.raphadev.antigravity-dev-toolkit/skills/` após sync.

| Skill | Como invocar | Usar para |
|-------|-------------|-----------|
| `spec` | "use skill spec" | PRD a partir de um pedido de feature |
| `plan` | "use skill plan" | PLAN baby-step a partir do PRD |
| `implement` | "use skill implement" | Executar um passo do PLAN |
| `code-review` | "use skill code-review" | Revisar diff ou branch vs PRD/PLAN |
| `commit` | "use skill commit" | Commit convencional e push |
| `dotnet-developer` | "use skill dotnet-developer" | Trabalho .NET simples sem SDD completo |
| `fix-build` | "use skill fix-build" | Diagnosticar/corrigir falhas de build ou teste |
| `test-coverage` | "use skill test-coverage" | Relatório de cobertura .NET (Coverlet) |
| `plan-repo-docs` | "use skill plan-repo-docs" | Plano de documentação para repositório alvo |
| `document-repo` | "use skill document-repo" | Um passo de `docs/documentation-plan/plan.md` |

### Guidelines compartilhados (carregar sob demanda)

**Não** ler preventivamente. Cada skill carrega o mínimo necessário quando invocada.

| Quando | Path (relativo ao plugin instalado) |
|--------|-------------------------------------|
| Implementação .NET / Clean Architecture | `_shared/dotnet_guidelines/clean-architecture.md` |
| Estilo C# e testes (xUnit/NUnit, Moq/NSubstitute, Shouldly) | `_shared/dotnet_guidelines/csharp-patterns.md` |
| Checklist pré-PR / pré-push | `_shared/dotnet_guidelines/checklist.md` |
| SOLID, DRY, KISS, YAGNI, encapsulamento | `_shared/code_guidelines/principles/` (arquivo por princípio) |
| Pipeline SDD (ordem, paths, confirmação) | `_shared/sdd_artifacts/PIPELINE.md` |

### Exclusões explícitas (budget de tokens)

- **Nunca pré-carregar** `_shared/code_guidelines/languages/**` ou fazer glob de toda a árvore `code-guidelines/`
- **Nunca pré-carregar** `dotnet_guidelines/` sem estar prestes a escrever ou revisar código .NET
- **Fora deste toolkit:** pipeline corporativo, Azure DevOps / work-item tracker APIs (PAT, PATCH, MCP), `setup`, `fix-pr-comments`, `fix-sonar-issues`, fluxos de análise estática

---

## Princípios de Carregamento

1. **Lazy-load apenas** — cada skill lê o que precisa quando invocada.
2. **Guidelines vencem conflitos** — se uma skill conflitar com `dotnet_guidelines`, seguir o arquivo de guideline.
3. **Um passo do PLAN por sessão** — persistir estado do PLAN; continuar em novo chat para o próximo passo.
4. **Disciplina de tokens** — não pré-carregar guidelines desnecessários.

---

## Editando este toolkit

Não commitar paths específicos do usuário (`C:\Users\...`, `/home/<user>/...`), tokens ou API keys. Usar `$HOME`, `~/.gemini/`, e placeholders como `<TOKEN>`.

---

Maintainer guide: `docs/MAINTAINER_GUIDE.md` · Install: `docs/INSTALL.md`
