# Spec Kit Workflow (setup → init → spec → plan → develop)

O workflow do Spec Kit é uma alternativa ao SDD clássico baseada na CLI oficial do [GitHub Spec Kit](https://github.com/github/spec-kit) e na estrutura de pastas `.specify/`.

---

## Passo Inicial: `use skill speckit_setup`
Verifica os pré-requisitos no Windows e instala a CLI.
**Exemplo:** `use skill speckit_setup`

O agente irá:
- Verificar o Python 3.10+.
- Perguntar e instalar o gerenciador `uv` caso não exista.
- Instalar a ferramenta `specify-cli` via `uv tool install`.
- Configurar o diretório global de manifestos do SDD.

---

## Passo 2: `use skill speckit_init`
Inicializa a estrutura do Spec Kit no repositório ativo.
**Exemplo:** `use skill speckit_init`

O agente irá:
- **Resolução de Storage:** Na primeira execução, pergunta se você prefere armazenar os planos localmente (no repositório) ou de forma global (em `~/.gemini/antigravity-ide/sdd/`) para não poluir o git do projeto. Essa escolha é salva no `manifest.json`.
- Criar a pasta `.specify/` no destino escolhido e gerar o arquivo de princípios do projeto (`.specify/memory/constitution.md`).

---

## Passo 3: `use skill speckit_spec`
Cria uma nova especificação técnica para uma funcionalidade.
**Exemplo:** `use skill speckit_spec`

O agente irá:
- Coletar a descrição da feature, o comportamento atual e o esperado.
- Gerar o identificador sequencial `NNN` (ex: `001`) e o slug da feature.
- Criar e salvar o arquivo `spec.md` sob o caminho `.specify/specs/NNN-<slug>/spec.md` (no local definido pelo storage ativo).

---

## Passo 4: `use skill speckit_plan`
Gera o plano e o checklist detalhados a partir da especificação.
**Exemplo:** `use skill speckit_plan — <path-to-spec.md>`

O agente irá:
- Analisar a `spec.md` e o `constitution.md` do projeto.
- Criar dois arquivos na mesma subpasta da feature:
  - `plan.md`: Design de arquitetura técnica e lista de arquivos afetados.
  - `tasks.md`: Lista de tarefas atômicas de 20-45 minutos com caixas de seleção (`- [ ]`).

---

## Passo 5: `use skill speckit_develop`
Executa as tarefas de forma iterativa passo a passo.
**Exemplo:** `use skill speckit_develop — <path-to-tasks.md>`

O agente irá:
- Ler a primeira tarefa pendente do arquivo `tasks.md`.
- Implementar o código e testes (em inglês).
- Atualizar a tarefa no arquivo `tasks.md` como concluída (`[x]`).
- Oferecer o conventional commit para salvar o progresso.
