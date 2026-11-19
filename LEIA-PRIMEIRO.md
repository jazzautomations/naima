# Naima

Agente pessoal que mora no seu Telegram e trabalha numa máquina sua. Feita pela Jazz Automations sobre o Hermes Agent (código aberto).

## Instalar

Abra o seu agente de código (Claude Code, Codex ou parecido), arraste este zip para a conversa e escreva:

> instala a Naima pra mim

Ele lê o `LEIA-ME-AGENTE.md`, faz quatro perguntas e monta tudo. Leva uns 15 minutos.

Tenha em mãos:
1. Uma máquina Linux ou macOS que fique ligada (pode ser esta ou uma VPS).
2. Um bot do Telegram: fale com o @BotFather, mande `/newbot` e copie o token.
3. Seu ID do Telegram: fale com o @userinfobot e copie o número.
4. O cérebro: conta ChatGPT Plus ou Pro, ou uma chave do OpenRouter.

Sem agente de código? `bash instalar.sh --help` mostra o caminho manual.

## O que vem

- **Identidade e regras** gravadas em arquivo, valendo desde a primeira mensagem.
- **Guarda de segredos**: token e senha ficam no cofre `naima-segredo`, fora de arquivo que o modelo lê; o Hermes ainda mascara valores de segredo na saída.
- **Execução direta**: ela faz o que você pede na hora, sem cartão de aprovação. Só confirma antes de apagar, gastar dinheiro ou mandar algo pra fora.
- **9 skills**: entrevista do dono, equipe (delegação), site no ar, landing page, proposta comercial, carrossel de Instagram, vídeo sanduíche, atendimento de leads, rotinas.
- **4 rotinas**: bom dia, acompanhamento de leads, revisão semanal, saúde da máquina. Ficam em silêncio quando não há nada a dizer.
- **Teste de fogo**: 27 provas de comportamento que dão nota à sua Naima.
- **Módulo atendente** (opcional): perfil separado para responder leads.

## Depois de instalar

Mande "oi" para o bot. Depois: "pode começar a entrevista".

Para mudar o jeito dela, edite `~/.hermes/SOUL.md` e mande `/new` no Telegram.
