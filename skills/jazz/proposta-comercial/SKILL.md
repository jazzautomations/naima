---
name: proposta-comercial
description: "Transformar uma conversa de venda em proposta em página web."
version: 1.0.0
author: Jazz Automations
metadata:
  hermes:
    tags: [vendas, proposta, html, jazz]
    related_skills: [landing-page, site-no-ar]
---

# Proposta comercial

Uma proposta é a conversa de venda devolvida por escrito, com preço e próximo passo. Vai como página web em link próprio, que abre no celular e pode ser atualizada sem reenviar arquivo.

## Entrada

A transcrição, o áudio ou as anotações da conversa, mais `dono/ofertas.md`. Sem registro da conversa, entreviste o dono: quem é o cliente, o que ele disse que dói, o que foi combinado, prazo e valor.

## Etapas

1. **Extrair**, nas palavras do cliente: situação atual, problema, o que isso custa a ele, o que ele quer no lugar, quem decide, prazo, objeções que apareceram. Guarde em `projetos/propostas/<cliente>/briefing.md`.
2. **Escopo**: o que será entregue, em itens verificáveis. E o que não está incluso, por escrito.
3. **Preço**: sai de `dono/ofertas.md` ou do dono. Você não precifica sozinha. Se couber, monte duas ou três opções (essencial, recomendada, completa) com a diferença clara entre elas.
4. **Rascunho** na estrutura abaixo.
5. **Dono revisa**. Nada vai ao cliente antes disso.
6. **Publicar** como página (skill `site-no-ar`) em endereço que não se adivinha, com `<meta name="robots" content="noindex">`.
7. **Registrar** em `pipeline/leads.md`: data de envio, valor, validade, data do acompanhamento.

## Estrutura da página

1. Para quem é e a data. Validade da proposta.
2. "O que entendi": a situação e o problema do cliente, com as palavras dele. É a seção que mais vende; se estiver genérica, volte à etapa 1.
3. O que proponho: a solução em linguagem do cliente, sem jargão.
4. Entregas e prazos, em tabela.
5. O que não está incluso.
6. Investimento: opções, forma de pagamento, o que acontece depois do aceite.
7. Por que nós: prova real e pertinente a este cliente.
8. Próximo passo: um botão, uma ação (responder no WhatsApp, assinar, pagar o sinal).

## Regras

- Nenhuma promessa de resultado numérico que o dono não possa garantir.
- Nenhum dado de outro cliente sem autorização.
- Valor por extenso junto ao número. Confira a soma.
- O visual segue a marca do dono, não a do cliente.
