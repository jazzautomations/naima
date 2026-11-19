# Naima

Agente pessoal que mora no seu Telegram e trabalha numa máquina sua. Feita pela [Jazz Automations](https://github.com/jazzautomations) sobre o [Hermes Agent](https://github.com/NousResearch/hermes-agent) (código aberto).

A Naima atende o dono em português do Brasil, guarda segredos fora do alcance do modelo, pede aprovação no Telegram antes de qualquer comando perigoso e vem com 9 skills prontas: entrevista do dono, delegação para uma equipe de subagentes, site no ar, landing page, proposta comercial, carrossel de Instagram, vídeo sanduíche, atendimento de leads e rotinas agendadas.

## Instalar com um agente de código

O jeito recomendado: abra o seu agente de código (Claude Code, Codex, Devin ou parecido), aponte este repositório e escreva:

> instala a Naima pra mim

Ele lê o [`LEIA-ME-AGENTE.md`](LEIA-ME-AGENTE.md) — o roteiro de instalação escrito para agentes — faz quatro perguntas e monta tudo. Leva uns 15 minutos.

```bash
git clone https://github.com/jazzautomations/naima.git
```

Tenha em mãos:

1. Uma máquina Linux ou macOS que fique ligada (pode ser esta ou uma VPS) — 5 GB livres, 2 GB de RAM.
2. Um bot do Telegram: fale com o [@BotFather](https://t.me/BotFather), mande `/newbot` e copie o token.
3. Seu ID do Telegram: fale com o [@userinfobot](https://t.me/userinfobot) e copie o número.
4. O cérebro: conta ChatGPT Plus/Pro, ou uma chave do [OpenRouter](https://openrouter.ai/keys) ou da Anthropic.

Sem agente de código? `bash instalar.sh --help` mostra o caminho manual. O guia para humanos está em [`LEIA-PRIMEIRO.md`](LEIA-PRIMEIRO.md).

## O que vem

- **Identidade e regras** gravadas em arquivo, valendo desde a primeira mensagem (`nucleo/SOUL.md`).
- **Guarda de segredos**: um bloqueio no próprio Hermes impede a Naima de ler token e senha, mesmo se alguém a convencer a tentar.
- **Aprovação**: comando perigoso só roda depois que você toca em "aprovar" no Telegram.
- **9 skills** em `skills/jazz/` — instalação sob demanda, descritas em `skills/jazz/DESCRIPTION.md`.
- **4 rotinas**: bom dia, acompanhamento de leads, revisão semanal, saúde da máquina. Ficam em silêncio quando não há nada a dizer.
- **Teste de fogo**: 27 provas de comportamento que dão nota à sua Naima (`teste-de-fogo/rodar.py`).
- **Módulo atendente** (opcional): perfil separado para responder leads (`modulos/atendente/`).

## Estrutura

```
instalar.sh          instalador idempotente (roda de novo sem perder memória nem segredos)
LEIA-PRIMEIRO.md     guia para humanos
LEIA-ME-AGENTE.md    roteiro de instalação para agentes de código
nucleo/              SOUL, workspace template, memória, guarda e naima-segredo
skills/jazz/         as 9 skills
modulos/atendente/   perfil opcional de atendimento a leads
teste-de-fogo/       suíte de avaliação comportamental
```
