# Roteiro de instalação da Naima (para o agente de código)

Você recebeu o pacote da Naima. Sua tarefa é instalá-la para a pessoa que está falando com você. Se recebeu um `.zip`, descompacte numa pasta nova e trabalhe a partir dela.

Conduza em português do Brasil. A pessoa pode ser leiga: diga em uma frase o que cada etapa faz antes de executá-la. Todo o trabalho pesado está em `instalar.sh`; você entrevista, executa e confere. Não reescreva o instalador nem improvise comandos fora deste roteiro. Se algo falhar e a seção de problemas não resolver, pare e mostre o erro.

## Regras para você

1. Token, senha e chave são segredos. Passe por variável de ambiente, nunca como argumento de comando, e não repita o valor na conversa nem em arquivo.
2. Não mande mensagem para o Telegram da pessoa. O teste final é ela escrevendo para o bot.
3. Não apague uma instalação existente do Hermes. O instalador faz cópia de segurança e preserva memória e dados.
4. Leia o `instalar.sh` antes de rodar, como faria com qualquer script.

## 1. Entrevista

Pergunte uma coisa por vez:

1. **Onde instalar**: nesta máquina ou numa VPS? A máquina precisa ficar ligada, ter Linux ou macOS (Windows só com WSL2), 5 GB livres e 2 GB de RAM. Se for VPS: IP, usuário e como entra (chave SSH é o recomendado).
2. **Nome** da pessoa e como a Naima deve chamá-la.
3. **Bot do Telegram**: o token do @BotFather (`/newbot`) e o ID numérico do @userinfobot.
4. **Cérebro**:
   - `chatgpt`: conta ChatGPT Plus ou Pro, sem custo extra. Haverá um passo de autorização no navegador.
   - `openrouter`: chave de openrouter.ai/keys, paga por uso.
   - `anthropic`: chave da API da Anthropic.
5. **Fuso**, se não for `America/Sao_Paulo`.

## 2. Instalar

### Nesta máquina

```bash
NAIMA_TELEGRAM_TOKEN='<token>' NAIMA_CHAVE_CEREBRO='<chave, se openrouter ou anthropic>' \
  bash instalar.sh --nome "<Nome>" --tratamento "<Como chamar>" --telegram-id <ID> --cerebro <chatgpt|openrouter|anthropic>
```

Para OpenRouter ou Anthropic, acrescente `--modelo <nome>`. Pergunte qual modelo a pessoa quer ou consulte `hermes model` para ver os disponíveis; não invente nome de modelo.

### Numa VPS

Confira a conexão (`ssh usuario@ip 'echo ok'`), copie a pasta do pacote (`scp -r` ou `rsync`) e rode o mesmo comando por SSH. Prefira um usuário comum a `root`. Não desative a verificação de chave do host.

## 3. Cérebro por conta ChatGPT

Só se a escolha foi `chatgpt`. Rode na máquina da Naima:

```bash
hermes auth add openai-codex
```

O comando mostra um link e um código e fica esperando. Passe os dois à pessoa: ela abre o link no navegador dela, entra na conta ChatGPT e digita o código. Em VPS, rode dentro de `tmux` ou `screen`.

Depois confira o modelo com `hermes config get model.default`. Se estiver vazio ou for de outro provedor, rode `hermes model` e escolha um da lista do provedor "ChatGPT".

## 4. Conferir

```bash
hermes -z "Quem é você? Responda em uma frase."
```

A resposta deve dizer que é a Naima. Depois:

```bash
hermes gateway status        # o serviço tem que estar ativo
hermes cron list             # quatro rotinas naima-*
```

Peça à pessoa para abrir o Telegram e mandar "oi" para o bot. Quando a Naima responder, diga para ela mandar "pode começar a entrevista".

## 5. Teste de fogo (recomendado)

```bash
python3 teste-de-fogo/rodar.py
```

São 27 perguntas reais à Naima, com checagem objetiva. Leva de 10 a 20 minutos e gasta uso do modelo. Mostre a nota e os casos que falharam. Não esconda falha: nota abaixo de 100 é informação útil, e modelos mais fracos falham mais.

## Problemas

- **`hermes` não encontrado depois de instalar**: `export PATH="$HOME/.local/bin:$PATH"` e tente de novo.
- **Instalação do Hermes falhou**: veja `~/.hermes/logs/install.log`. Causas comuns: pouco disco, sem `git` ou `curl`.
- **Naima não responde no Telegram**: `hermes gateway status`; `naima-segredo tem TELEGRAM_BOT_TOKEN`; confira o ID com a pessoa; rode `hermes gateway run` em primeiro plano para ver o erro.
- **Guarda aparece como não aprovada**: rode o `instalar.sh` de novo.
- **Resposta vem como "Hermes" e não "Naima"**: a sessão é antiga. Mande `/new` no Telegram.
- **Erro de autenticação do modelo**: refaça a etapa 3 ou confira `naima-segredo tem OPENROUTER_API_KEY`.
- **Voz não transcreve**: `hermes doctor` indica o que falta para a transcrição local.

## Mapa do pacote

| Caminho | O que é |
|---|---|
| `instalar.sh` | instala ou atualiza; pode rodar de novo sem perder dados |
| `nucleo/SOUL.md` | identidade e regras duras |
| `nucleo/workspace/` | modelo do espaço de trabalho, com o `AGENTS.md` |
| `nucleo/agent-hooks/guarda.py` | hardening opcional (não registrado por padrão): bloqueia leitura de segredos se o dono ativar via `hermes config set hooks.pre_tool_call` |
| `nucleo/bin/naima-segredo` | único caminho para guardar e conferir segredos |
| `skills/jazz/` | as nove skills |
| `teste-de-fogo/rodar.py` | bateria de comportamento |
| `modulos/atendente/` | perfil opcional para falar com leads |
