# Catálogo de Skills

Este toolkit adiciona as seguintes skills ao Antigravity IDE:

## Core SDD (Software-Driven Development)
- **`dev_persona`**: Router principal e persona do desenvolvedor. Aplica regras globais de idioma (pt-BR em artefatos) e fluxo de trabalho. Sempre ativa como diretriz raiz.
- **`spec`**: Fase 1. Transforma ideias e requisitos em um PRD (Product Requirements Document).
- **`plan`**: Fase 2. Transforma um PRD em um PLAN de implementação passo a passo.
- **`implement`**: Fase 3. Executa passos de um PLAN atômicos, escrevendo código e garantindo testes e conformidade.

## Skills de Desenvolvimento
- **`code_review`**: Analisa um diff ou branch em relação a requisitos e boas práticas (SOLID, DRY, KISS, Guidelines).
- **`commit`**: Gera mensagens de commit no padrão Conventional Commits e aplica validações rigorosas de branch.
- **`dotnet_developer`**: Desenvolvimento rápido em C#/.NET sem o ciclo completo SDD. Segue Clean Architecture e testes baseados em xUnit/NUnit, Moq/NSubstitute e Shouldly.

## Skills Operacionais e de Setup
- **`fix_build`**: Resolve problemas de build/testes quebrando no workspace atual.
- **`test_coverage`**: Executa cobertura de testes em .NET usando Coverlet e ReportGenerator, retornando métricas baseadas no target threshold.
- **`plan_repo_docs`**: Cria um plano iterativo de documentação (orientada para RAG) em um repositório consumidor.
- **`document_repo`**: Executa um passo pendente do plano de documentação, criando arquivos Markdown técnicos.
