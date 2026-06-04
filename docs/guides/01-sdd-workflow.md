# Fluxo SDD (Spec → Plan → Implement)

O fluxo principal para features e épicos garante previsibilidade, qualidade e contexto documentado (importante para o raciocínio da LLM em longas execuções).

## Passo 1: `use skill spec`
Inicie pedindo ao agente para especificar uma feature.  
**Exemplo:** `use skill spec — adicionar exportação para PDF de pedidos`

O agente:
- Lhe fará perguntas se houver ambiguidades nos requisitos ou escopo.
- Solicitará aprovação do artefato antes de salvar.
- Criará um arquivo de PRD (Product Requirements Document) tipicamente em `PRD/NNN_feature_slug.md`.

## Passo 2: `use skill plan`
Uma vez que o PRD esteja pronto e revisado, peça para planejar o desenvolvimento.  
**Exemplo:** `use skill plan — PRD/001_exportacao_pdf.md`

O agente:
- Lera o PRD e desenhará a arquitetura e modificações exatas arquivo-por-arquivo.
- Quebrará a implementação em passos atômicos iterativos (ex: Domínio, Infraestrutura, Aplicação, API, Testes).
- Criará um arquivo `PLAN/PLAN_001_exportacao_pdf.md` com checkboxes (`[ ]`).

## Passo 3: `use skill implement`
Trabalhe em cada passo do plano individualmente para mitigar perda de contexto.  
**Exemplo:** `use skill implement — PLAN/PLAN_001_exportacao_pdf.md — Step 1`

O agente:
- Focará estritamente no passo solicitado.
- Modificará o código adequadamente.
- Atualizará o arquivo de PLAN, marcando o passo como concluído (`[x]`).
- Sugerirá a execução do commit assim que o passo terminar.

> **Importante:** Após o commit, não acumule contexto. Em uma nova mensagem (ou nova sessão de chat), repita a skill `implement` para o `Step 2`, e assim sucessivamente.
