# Skills Operacionais e de Qualidade

As skills operacionais ajudam em tarefas rotineiras de manutenção, revisões e tarefas secundárias ao desenvolvimento principal.

## 1. Code Review (`code_review`)
**Invocação:** `use skill code_review`

O agente avalia a branch atual ou um diff explícito contra os requisitos de um PRD/PLAN ou apenas contra as boas práticas globais (`_shared/code_guidelines` - SOLID, DRY, KISS, YAGNI, Encapsulation) e guidelines locais da stack. 
Retorna um relatório hierarquizado dividindo em *blockers* e sugestões, além de um selo de aprovação (Pass/Fail). Pode gerar PR via `gh` (GitHub CLI) se solicitado.

## 2. Commit (`commit`)
**Invocação:** `use skill commit`

Lê as mudanças da *working tree* (staged e unstaged), formata uma mensagem de commit adequada no padrão *Conventional Commits* (ex: `feat(orders): add recalculation limit`), e commita.
**Regra rígida:** O agente nunca realizará auto-commit sem que você primeiro chancele a mensagem no chat. Também impõe bloqueios contra commit em branches proibidas (main, master).

## 3. Test Coverage (`test_coverage`)
**Invocação:** `use skill test_coverage`

Executa a cobertura de testes .NET localmente (Coverlet + ReportGenerator) reportando no chat métricas detalhadas de porcentagem de linhas, indicando se as *mudanças recentes* superam o limiar aceitável (default 80%).

## 4. Fix Build (`fix_build`)
**Invocação:** `use skill fix_build`

Caso o build ou algum teste quebre e você queira um diagnóstico rápido. Ele executará `dotnet build/test` (ou lerá logs colados no chat), diagnosticará o root cause (problema de cultura, falha de assertions, bug introduzido, package mismatch), sugerirá a correção e aplicará o fix apenas se você aprovar, refazendo o teste para garantir a estabilidade.

## 5. Documentação baseada em RAG (`plan_repo_docs` e `document_repo`)
Essenciais quando o Antigravity IDE for atuar em um novo repositório desconhecido e necessitar de um contexto textual rico para Retrieval-Augmented Generation (RAG).

- `use skill plan_repo_docs`: Explora o repositório, define um idioma alvo para a documentação técnica do produto, escreve um `docs/overview.md` abrangente e monta um roteiro atômico de documentação em `docs/documentation-plan/plan.md`.
- `use skill document_repo`: Roda de forma avulsa a próxima tarefa pendente mapeada pelo plano de documentação criado acima.
