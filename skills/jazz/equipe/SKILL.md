---
name: equipe
description: "Delegar tarefa longa a um ajudante com papel definido."
version: 1.0.0
author: Jazz Automations
metadata:
  hermes:
    tags: [delegacao, equipe, jazz]
---

# Equipe

Use quando a tarefa leva mais de uns dois minutos ou pede um especialista. O ajudante criado por `delegate_task` nasce em branco: não conhece o dono, não leu o SOUL, não tem memória e não pode mandar mensagem. Tudo que ele precisa saber vai no `context`.

## Papéis

| Papel | Quando | Briefing |
|---|---|---|
| dev | código, API, deploy, debug, infraestrutura | `references/dev.md` |
| copy | página de venda, roteiro, legenda, e-mail, proposta | `references/copy.md` |
| ops | planilha, organização de arquivos, processo, checagem em lote | `references/ops.md` |
| pesquisa | mercado, concorrente, fornecedor, fato atual | `references/pesquisa.md` |

Não sabe qual? Se o resultado é um arquivo que roda, é dev. Se é um texto que alguém lê, é copy. Se é uma resposta com fontes, é pesquisa. O resto é ops.

## Como delegar

1. Carregue o briefing do papel com `skill_view("equipe", file_path="references/<papel>.md")`.
2. Monte o `context` nesta ordem:
   - o briefing do papel, inteiro;
   - o que o dono quer e para quê, em duas ou três frases;
   - caminhos absolutos dos arquivos envolvidos;
   - o que já foi tentado ou descartado;
   - para copy: o conteúdo de `dono/voz.md` e o trecho relevante de `dono/ofertas.md`;
   - o critério de pronto e o formato da devolução.
3. O `goal` é uma frase com verbo e resultado: "Publicar a landing X em Y e devolver a URL testada".
4. Avise o dono em uma linha o que foi delegado e siga disponível.

## Quando o ajudante devolve

Confira antes de repassar. Abra o arquivo, rode o teste, acesse a URL. O que você observou vira VERIFICADO; o que só o ajudante afirmou continua INFERIDO, e você diz isso ao dono.

Tarefas independentes podem ir em paralelo. Tarefas que dependem uma da outra vão em sequência, com o resultado da primeira no `context` da segunda.

## Não delegue

- Conversa, opinião e decisão: isso é seu.
- Qualquer coisa que sai para fora (enviar, postar, publicar em produção, pagar): o ajudante prepara, o dono aprova, você executa.
- Leitura de segredo: ninguém lê.
