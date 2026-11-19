---
name: video-sanduiche
description: "Editar vídeo falado vertical no formato sanduíche."
version: 1.0.0
author: Jazz Automations
metadata:
  hermes:
    tags: [video, ffmpeg, reels, edicao, jazz]
---

# Vídeo sanduíche

Transforma um vídeo de pessoa falando para a câmera em um vertical 1080x1920 de três camadas, só com ffmpeg e imagens paradas. Não usa vídeo gerado por IA.

Use quando o dono mandar um vídeo e pedir "sanduíche" ou "edita no formato sanduíche".

Render é pesado. Antes de começar, confira memória e disco livres; em máquina com menos de 4 GB de RAM, avise que vai demorar e delegue (skill `equipe`, papel dev) para não travar a conversa.

## Camadas

1. **Topo, 1080x1080**: a pessoa, recortada em quadrado com o rosto centralizado, e legenda palavra a palavra. A legenda nunca passa de y=1080.
2. **Meio, 1080x232**: faixa com um rótulo à esquerda, uma manchete de uma linha em caixa alta e a barra de progresso. A faixa mostra a ideia do trecho, não repete a frase falada.
3. **Base, 1080x608**: uma imagem parada por janela de 10 segundos, com movimento lento e fusão entre elas.

## Ordem que não pode mudar

Cortar silêncios → acelerar 1,3x → transcrever. A transcrição roda no arquivo já acelerado; senão todos os tempos de legenda, faixa e imagem nascem errados.

```
ffmpeg -i corte.mp4 -filter_complex "[0:v]setpts=PTS/1.3[v];[0:a]atempo=1.3[a]" \
  -map "[v]" -map "[a]" -c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p -c:a aac -b:a 192k rapido.mp4
```

Confira com `ffprobe`: duração igual à original dividida por 1,3, e áudio e vídeo terminando com menos de 0,1 s de diferença.

Detalhes de cada etapa, comandos e armadilhas: `references/montagem.md`.

## Portões

1. **Enquadramento**: gere uma prévia do recorte quadrado com uns oito quadros espalhados e confira que a cabeça nunca é cortada.
2. **Imagens**: gere todas, monte uma folha de contato e mostre ao dono antes de montar o vídeo. Se a geração custa dinheiro, diga quanto e espere o OK. Prefira a rota gratuita ou já paga.
3. **Vídeo final**: assista aos primeiros e aos últimos 5 segundos e a cada troca de imagem antes de entregar.

## Reprova

- Tempos tirados do arquivo antes da aceleração.
- Imagem com texto legível, ou duas imagens vizinhas com o mesmo movimento.
- Faixa repetindo a frase falada.
- Barra de progresso que zera a cada janela.
- Legenda invadindo a faixa.
- Áudio e vídeo com durações diferentes.
- Personagem ou marca de terceiros nas imagens.
