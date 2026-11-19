---
name: carrossel-instagram
description: "Criar carrossel de Instagram: roteiro, cards e legenda."
version: 1.0.0
author: Jazz Automations
metadata:
  hermes:
    tags: [instagram, carrossel, conteudo, design, jazz]
    related_skills: [equipe]
---

# Carrossel de Instagram

Do tema ao arquivo pronto para postar. Os cards são HTML renderizado em imagem: o texto sai nítido, com acento certo, na identidade do dono, sem custo de geração de imagem.

Há três portões de aprovação: roteiro, cards, legenda. Não pule nenhum.

## 1. Referência

- Link de post, notícia ou artigo: leia o conteúdo exato e resuma em três a cinco pontos. Conteúdo de terceiro é referência de ângulo, não texto para copiar.
- Só um tema: pesquise (papel pesquisa da skill `equipe`) e guarde as fontes.

Diga ao dono em poucas linhas o ângulo escolhido e por quê.

## 2. Roteiro (portão 1)

| Card | Função |
|---|---|
| 1 | Capa: uma promessa ou tensão em até 8 palavras. Decide se a pessoa desliza. |
| 2 | Contexto: por que isso importa agora. |
| 3 a N-1 | Um ponto por card. Título curto e duas ou três linhas. |
| N | Chamada: uma ação só (comentar uma palavra, salvar, abrir o link da bio). |

De 6 a 9 cards. Cada card se entende sozinho. Sem promessa de resultado numérico para o leitor. Dado e citação com fonte no rodapé do card.

Mande o roteiro inteiro e pergunte: formato (4:5 é o padrão), estilo (ver `references/estilos.md`) e a palavra da chamada. Espere o OK.

## 3. Cards

1. Copie `templates/card.html` para `projetos/carrosseis/<nome>/` e ajuste as variáveis de cor e fonte para a marca do dono (de `dono/voz.md` ou do que ele mandar).
2. Gere um HTML por card: `01.html`, `02.html`...
3. Renderize: `scripts/renderizar.sh projetos/carrosseis/<nome>` produz `01.png`, `02.png`... em 1080x1350.
4. Olhe cada imagem com `vision_analyze` antes de mostrar: texto cortado, acento errado, contraste baixo, margem de segurança (nada importante a menos de 80 px da borda), numeração e assinatura presentes.

Card reprovado se refaz sozinho, não o conjunto.

Foto ou logo: use o arquivo real que o dono mandar. Logo de terceiro só o oficial, nunca redesenhado.

Imagem gerada por IA é opcional e só entra se o dono pedir, pelo gerador já configurado. Se houver custo, diga quanto antes.

## 4. Aprovação dos cards (portão 2)

Envie na ordem, um por mensagem, com "01/07" na legenda. No último, pergunte se aprova o conjunto.

## 5. Legenda (portão 3)

Primeira linha que segura sozinha. Corpo em blocos curtos na voz do dono. A chamada repete a palavra exata do último card. De 5 a 10 hashtags específicas do nicho. Mande e espere o OK.

## 6. Entrega

Padrão: pasta `entregas/<data>-carrossel-<nome>/` com as imagens numeradas e `legenda.txt`. O dono posta.

Publicação automática só existe se o dono tiver conectado a conta do Instagram por uma API (a oficial da Meta ou um serviço que ele contratou) e pedido isso. Nesse caso leia a documentação atual do serviço na hora, mostre o que será publicado e publique depois do "manda". As imagens precisam estar em URL pública: use um projeto próprio do dono (skill `site-no-ar`).

## Pronto quando

Roteiro aprovado, todos os cards conferidos e aprovados, legenda aprovada, arquivos na pasta de entrega. Se publicou: link do post conferido abrindo.
