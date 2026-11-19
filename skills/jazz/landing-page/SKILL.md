---
name: landing-page
description: "Criar landing page em HTML estático, pronta para publicar."
version: 1.0.0
author: Jazz Automations
metadata:
  hermes:
    tags: [landing, html, design, copy, jazz]
    related_skills: [site-no-ar, equipe]
---

# Landing page

Uma página, um objetivo, um botão. HTML estático em arquivo único, sem framework, que abre rápido no celular.

## Antes de escrever

Tenha em mãos, de `dono/ofertas.md` e `dono/voz.md` ou perguntando:

1. O que a pessoa faz ao final (comprar, agendar, deixar contato) e para onde o botão leva.
2. Para quem é, em uma frase.
3. A prova que existe de verdade: números do dono, depoimentos, clientes, fotos.
4. Identidade: cores, logo, fontes, um site ou post que ele considera a cara da marca.

Sem o item 1 não há página. Sem o 3, a página sai sem a seção de prova: nunca invente depoimento, número ou logo de cliente.

## Estrutura

1. Dobra inicial: promessa específica, uma linha de apoio, botão. Deve funcionar sozinha.
2. Para quem é e para quem não é.
3. O problema, nas palavras do cliente.
4. Como funciona, em três passos no máximo.
5. Prova.
6. Oferta: o que está incluso, preço se o dono autorizou mostrar, garantia se existe.
7. Perguntas frequentes: as objeções reais.
8. Botão de novo.

Texto: delegue ao papel copy da skill `equipe` com a voz do dono, ou escreva seguindo as mesmas regras.

## Visual

Escolha uma direção em `references/direcoes.md` que combine com a marca e siga-a inteira. Não misture.

Regras que valem para todas:
- Parta da identidade que já existe. Cor solta, só se derivada da paleta da marca.
- Tipografia com caráter. Evite Inter, Roboto e Arial como fonte de título.
- Nada que grite "feito por IA": gradiente roxo de fundo, cartão com borda colorida à esquerda, emoji como ícone, ilustração desenhada em SVG, números de enfeite.
- Imagem real ou espaço reservado com a legenda do que entra ali. Peça o arquivo ao dono.
- Largura de leitura de até 70 caracteres. Contraste de texto AA.
- Celular primeiro: teste em 375 px de largura.

## Técnica

- Um `index.html` com CSS embutido. JavaScript só se necessário.
- `<title>`, descrição, Open Graph (título, descrição, imagem 1200x630), favicon.
- Imagens comprimidas, com `width`, `height`, `alt` e `loading="lazy"` abaixo da dobra.
- Botão é um link de verdade para o destino. Formulário só com destino que funciona.
- Medição: só com a ferramenta que o dono já usa. Não adicione rastreador por conta própria.

## Verificação

Abra no navegador em 375 px e em 1280 px e olhe a captura de tela. Clique em todo link. Confira ortografia e acentuação. Só então mostre ao dono, como prévia.

Publicação: skill `site-no-ar`, depois do OK.
