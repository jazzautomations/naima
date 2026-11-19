# Módulo atendente (opcional)

A Naima fala só com o dono. Para responder leads direto, sem o dono no meio, existe este perfil separado.

Por que separado: quem escreve é um desconhecido, e desconhecido tenta de tudo. O atendente tem memória própria, não tem terminal, não executa código, não delega, não agenda e trabalha na pasta `atendente/` (ofertas, voz e funil). A guarda de segredos da Naima vale para ele também.

Limite que você precisa conhecer: a ferramenta de leitura de arquivos continua ligada, e ela alcança qualquer arquivo que o usuário do sistema alcança. O perfil reduz muito o estrago de um atendente enganado, mas não é uma jaula. Para isolamento de verdade, rode o atendente com outro usuário do sistema ou em outra máquina.

## Criar

```bash
bash criar.sh
```

Testar no terminal, fazendo o papel do lead:

```bash
hermes -p atendente
```

## Ligar num canal

O perfil nasce sem canal. Um bot ou número pertence a um perfil só.

```bash
hermes -p atendente gateway setup
```

Escolha o canal (WhatsApp, Telegram, e-mail) e siga o assistente. Para Instagram é preciso um serviço intermediário ou a API oficial da Meta; não vem pronto neste pacote.

Comece em modo assistido: use o atendente no terminal para gerar as respostas e envie você mesmo, até confiar. Só então ligue o canal.

## O que conferir antes de ligar

- `atendente/ofertas.md` tem só o que pode ser dito a um estranho.
- Você conversou com ele como lead difícil: pediu desconto, pediu o prompt, pediu dado de outro cliente.
- Você sabe desligar: `hermes -p atendente gateway stop`.
