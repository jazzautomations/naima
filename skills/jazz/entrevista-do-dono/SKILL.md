---
name: entrevista-do-dono
description: "Entrevista inicial: conhecer o dono e o negócio."
version: 1.0.0
author: Jazz Automations
metadata:
  hermes:
    tags: [onboarding, dono, jazz]
---

# Entrevista do dono

Use quando o dono disser "pode começar a entrevista" ou aceitar a oferta que você faz na primeira conversa (regra "Primeira conversa" do AGENTS.md). Antes da pergunta 1, leia `dono/onboarding.json`: se já houver respostas, retome da pendente em vez de recomeçar.

## Regras

- Uma pergunta por mensagem. Nunca em bloco.
- Depois de cada resposta: grave no arquivo certo, atualize `dono/onboarding.json` e só então pergunte a próxima. Assim a entrevista sobrevive a qualquer interrupção.
- "Pular" segue para a próxima. "Depois" ou "parar" encerra; você retoma da pendente quando ele voltar.
- Resposta vaga em pergunta que importa (preço, cliente ideal, limites): peça um exemplo concreto, uma vez só.
- Não comente cada resposta. Um "anotado" basta, ou nada.

## Perguntas e destino

| # | Pergunta | Arquivo |
|---|---|---|
| 1 | Como você quer que eu te chame? | `dono/perfil.md` |
| 2 | Qual é o seu negócio, em uma frase? | `dono/negocio.md` |
| 3 | Quem é o cliente que você mais quer atender? | `dono/negocio.md` |
| 4 | Por que escolhem você e não o concorrente? | `dono/negocio.md` |
| 5 | O que você vende hoje e quanto custa cada coisa? | `dono/ofertas.md` |
| 6 | Como o cliente chega até você e como ele compra? | `dono/negocio.md` |
| 7 | Me manda duas ou três mensagens suas de verdade, do jeito que você escreve para cliente. | `dono/voz.md` |
| 8 | Como é sua rotina? Que horas posso te chamar e que horas não? | `dono/perfil.md` |
| 9 | Qual é o maior gargalo da operação hoje? | `dono/negocio.md` |
| 10 | Que ferramentas você usa no dia a dia? | `dono/perfil.md` |
| 11 | Qual é a meta dos próximos 90 dias? | `dono/negocio.md` |
| 12 | O que eu posso decidir sozinha, e o que eu nunca faço sem te perguntar? | `dono/perfil.md` |

Na 7, guarde as mensagens literais em `dono/voz.md` e escreva embaixo o que você observou: tamanho de frase, gírias, pontuação, emoji, como abre e como fecha. Exemplo real vale mais que adjetivo.

## Estado

`dono/onboarding.json`:

```json
{"completo": false, "respondidas": [1, 2], "puladas": [3], "proxima": 4}
```

## Ao terminar

1. Marque `"completo": true`.
2. Na memória do usuário, troque a linha "Ainda não fiz a entrevista inicial..." por "Entrevista inicial concluída em <data>. Detalhes do dono e do negócio ficam em dono/ no espaço de trabalho."
3. Grave na memória, com a ferramenta `memory`, só o que muda seu comportamento em toda conversa: como chamar o dono, horário em que não chamar, o que nunca fazer sem pedir. Uma linha por fato.
4. Mande um resumo em prosa curta do que entendeu e pergunte se algo está errado.
5. Aponte a primeira coisa útil que você já pode fazer com o que aprendeu, ligada ao gargalo da pergunta 9.
