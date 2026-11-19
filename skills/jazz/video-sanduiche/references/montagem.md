# Montagem, etapa por etapa

## Imagens da base

- Uma imagem por janela de 10 s. A mesma janela vale para a faixa e para a barra de progresso.
- Gere em paisagem (1536x1024 ou parecido) e recorte para 1080x608.
- No pedido de imagem: assunto no centro, 70% da área; topo e base só com ambiente, porque o recorte come as bordas. Sem texto legível. Estilo conforme a identidade do dono.
- Movimento: ampliação de 1,00 a 1,06 ao longo da janela, alternando entre aproximar, deslizar para a esquerda e deslizar para a direita. Fusão de 0,7 s entre imagens.

```
ffmpeg -loop 1 -i cena.png -t <DUR> -vf \
 "scale=2160:-2,zoompan=z='min(1.06,1+0.0004*on)':d=<DUR*30>:s=1080x608:fps=30,setsar=1" \
 -c:v libx264 -crf 18 -pix_fmt yuv420p cena.mp4
```

Sempre com `-t` explícito. Só o `d=` gera centenas de segundos de vídeo.

## Recorte do topo

`crop=1080:1080:0:<deslocamento>`. Extraia uns oito quadros ao longo do vídeo e escolha o deslocamento que tira o teto vazio sem cortar a cabeça em nenhum deles, nem quando a pessoa se inclina.

## Legenda

Palavra a palavra, fonte pesada, a palavra de impacto em caixa alta. A base do texto fica logo acima de y=1080.

## Gancho

Nos primeiros segundos a manchete ocupa a faixa do meio em até duas linhas, fonte pesada, ajustada à largura. Corte 0,15 s antes da primeira palavra. No fim, 0,3 a 0,4 s de silêncio e transição de 0,4 s.

## Barra de progresso

Avança de forma contínua pelo vídeo inteiro. Em cada janela ela vai da fração inicial à fração final daquela janela (fração = instante / duração total já acelerada). Nunca vai de 0 a 100% dentro de um trecho.

## Junção

1. Recorte do topo com o áudio (`-map 0:a -c:a copy`).
2. Faixas concatenadas na ordem, aparadas na duração exata.
3. Imagens animadas concatenadas com `scale=1080:608,fps=30` e a fusão de 0,7 s.
4. `vstack` das três camadas. Use `tpad=stop_mode=clone` em toda camada para igualar à duração da base.
5. `-frames:v` nunca entra no comando que junta o áudio.
6. Chamada única no fim. Música de fundo só se o dono pedir, bem baixa (perto de -42 dB).

## Conferência final

`ffprobe` do arquivo: 1080x1920, 30 qps, duração de áudio e vídeo iguais. Extraia um quadro a cada troca de imagem e olhe.
