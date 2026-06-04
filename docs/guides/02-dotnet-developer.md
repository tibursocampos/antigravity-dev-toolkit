# Desenvolvimento .NET (`dotnet_developer`)

Para correções menores, refatorações pontuais ou tarefas técnicas curtas (menos de 4 horas, tocando poucos arquivos), você pode pular o ciclo completo SDD e usar a skill direta de desenvolvimento .NET.

## Exemplo de uso
`use skill dotnet_developer — corrigir null pointer no OrderService quando pedido não tem itens`

## O que o agente fará:
1. Analisará o repositório (`*.sln`) e a estrutura de pastas existente.
2. Pedirá que você crie/checkout em uma branch válida (`feature/` ou `feat/`) se ainda não estiver em uma.
3. Proporá micro-passos no próprio chat para organizar as alterações.
4. Modificará o código seguindo estritamente os padrões definidos em `_shared/dotnet_guidelines/`:
   - Clean Architecture
   - FluentValidation
   - xUnit + Moq + FluentAssertions para a stack de testes
   - Regras rígidas de formatação em `csharp-patterns.md` (ex: um tipo por arquivo, assinaturas de método quebradas corretamente, proibição de magic strings e substituição por consts PascalCase).
5. Executará build e testes locais via `dotnet test` e validará o sucesso.
6. Sugerirá o uso da skill de commit (`use skill commit`) para confirmar as mudanças.

## Quando NÃO usar
Se a feature for transversal abrangendo múltiplas camadas densas (UI + Backend + Banco + Mensageria), se envolver migrações grandes do EF Core, ou se houver grande ambiguidade/complexidade de negócio nos requisitos, o agente (orientado pela `dev_persona`) te interromperá e recomendará o fluxo de `spec` e `plan`.
