# Direções visuais

Cada uma é um sistema fechado. Escolha pela marca, não pelo gosto.

| Direção | Serve para | Fundo e cor | Tipografia | Marca registrada |
|---|---|---|---|---|
| Editorial | consultoria, educação, autoridade | papel claro, preto, um acento | serifada de texto no título, sem serifa no corpo | colunas, fios finos, muito branco |
| Cartaz | comida, evento, marca jovem | cor chapada forte, preto, branco | grotesca pesada e condensada | blocos grandes, sombra sólida, carimbo |
| Terminal | produto técnico, dev, automação | quase preto, verde ou âmbar | monoespaçada | prompt, cursor, bordas de 1 px |
| Luxo escuro | serviço premium, estética, imóvel | preto quente, dourado fosco | serifada de alto contraste | fotos grandes, pouco texto, espaçamento largo |
| Brutalista | estúdio, portfólio, manifesto | branco, preto, uma cor primária | grotesca neutra enorme | grade aparente, sem arredondado, sem sombra |
| Clínico | saúde, jurídico, finanças | branco, azul ou verde profundo | humanista sem serifa | hierarquia calma, ícones de linha, confiança |
| Caloroso | serviço local, artesanal, família | creme, terracota, verde oliva | serifada arredondada | fotos de gente, cantos suaves, textura de papel |
| Vitrine | loja, catálogo, cardápio | neutro, a cor vem do produto | sem serifa compacta | grade de produtos, preço visível, botão por item |

## Como aplicar

1. Defina no topo do CSS as variáveis: `--fundo`, `--texto`, `--acento`, `--fonte-titulo`, `--fonte-corpo`, `--raio`, `--espaco`.
2. Dois tamanhos de título, um de corpo, um de legenda. Não mais.
3. O acento aparece no botão e em um detalhe. Se está em todo lugar, não é acento.
4. Fonte: no máximo duas famílias, carregadas com `font-display: swap`.
