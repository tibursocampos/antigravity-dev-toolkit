# Instalação: antigravity-dev-toolkit

Este repositório contém o toolkit pessoal de desenvolvimento para o Antigravity IDE (Gemini).

## Pré-requisitos
- Windows (Powershell)
- Antigravity IDE instalado e em execução (para que a pasta `~/.gemini` exista)

## Passos para Instalação

1. Clone o repositório na sua máquina (ex: `D:\Source\Repos\antigravity-dev-toolkit`).
2. Abra um terminal PowerShell na raiz do repositório.
3. Execute o script de sincronização:

   ```powershell
   .\scripts\sync-antigravity.ps1
   ```

4. O script copiará o diretório `plugin/` para a pasta de plugins do Antigravity IDE (`~/.gemini/antigravity-ide/plugins/Local.raphadev.antigravity-dev-toolkit`).
5. A cópia é idempotente (baseada em hashes SHA-256), copiando apenas arquivos modificados, evitando overwrites desnecessários.
6. Opcionalmente reinicie as sessões de chat no Antigravity IDE para que ele carregue/indexe as novas skills com eficácia.

## Atualização
Sempre que fizer alterações locais nas skills ou regras (`_shared/`) neste repositório base, rode `.\scripts\sync-antigravity.ps1` novamente para aplicar as mudanças ao IDE.
