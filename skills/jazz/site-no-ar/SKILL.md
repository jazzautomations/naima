---
name: site-no-ar
description: "Publicar site: GitHub, Vercel e domínio no Cloudflare."
version: 1.0.0
author: Jazz Automations
metadata:
  hermes:
    tags: [site, deploy, github, vercel, cloudflare, jazz]
---

# Site no ar

Fluxo fixo para todo site do dono: o código mora no GitHub, a Vercel publica a cada push, o Cloudflare aponta o domínio.

## Acessos (uma vez só)

Confira com `naima-segredo tem NOME`. O que faltar, guie o dono a criar, um por vez, e guarde com `naima-segredo guardar NOME`. Depois de guardar, peça que ele apague a mensagem com o token.

| Nome | Onde criar | Permissão mínima |
|---|---|---|
| `GITHUB_TOKEN` | github.com → Settings → Developer settings → Fine-grained tokens | Contents e Administration (leitura e escrita) nos repositórios escolhidos |
| `VERCEL_TOKEN` | vercel.com → Account Settings → Tokens | escopo da conta ou do time do dono |
| `CLOUDFLARE_API_TOKEN` | dash.cloudflare.com → My Profile → API Tokens, modelo "Edit zone DNS" | só a zona do domínio |

As telas mudam. Se o caminho acima não bater com o que o dono vê, abra a documentação oficial e siga a de lá.

Os comandos leem o token do ambiente pelo nome. Nunca escreva o valor em comando, arquivo ou mensagem.

## Passos

1. **Projeto** em `projetos/<nome>/`. Site estático é um `index.html` e seus arquivos. Teste local abrindo o arquivo ou com `python3 -m http.server`.
2. **Repositório**: `git init`, primeiro commit, criar o repositório privado pela API do GitHub (`POST /user/repos`) e `git push`. Autentique com um helper de credencial que lê `GITHUB_TOKEN` do ambiente; não ponha o token na URL do remoto.
3. **Vercel**: `npx vercel link` e `npx vercel deploy --prod --token "$VERCEL_TOKEN"`, ou conecte o repositório pelo painel para publicar a cada push. Guarde a URL `.vercel.app`.
4. **Verifique a URL da Vercel** antes de mexer em domínio: status 200, título certo, imagens carregando, versão de celular.
5. **Domínio**: adicione o domínio ao projeto na Vercel e crie no Cloudflare o registro que a Vercel pedir (em geral CNAME do subdomínio para o alvo indicado por ela). Comece com o proxy do Cloudflare desligado (nuvem cinza) até o certificado sair.
6. **Verifique o domínio**: `curl -sI https://dominio` com 200 e o conteúdo certo. DNS pode levar alguns minutos.

## Pedem OK do dono

- Criar repositório público.
- Qualquer mudança em DNS de domínio que já está em uso. Mostre o registro atual e o novo, lado a lado.
- Publicar em produção por cima de um site que já está no ar. Mostre antes uma URL de prévia.

## Entrega

URL final, URL do repositório, o que foi verificado (com a saída do `curl`) e o que não foi.
