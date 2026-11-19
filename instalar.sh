#!/usr/bin/env bash
# Instalador da Naima (Jazz Automations) sobre o Hermes Agent.
# Pode rodar quantas vezes quiser: atualiza a Naima sem apagar memória, dados do dono nem segredos.
#
#   bash instalar.sh --nome "Maria Silva" --tratamento "Maria" [opções]
#
#   --nome NOME            nome do dono (obrigatório na primeira vez)
#   --tratamento COMO      como a Naima chama o dono (padrão: primeiro nome)
#   --fuso ZONA            fuso IANA (padrão: America/Sao_Paulo)
#   --workspace PASTA      espaço de trabalho (padrão: ~/naima)
#   --telegram-id N        ID numérico do dono no Telegram
#   --cerebro TIPO         chatgpt | openrouter | anthropic | manter (padrão: manter)
#   --modelo NOME          modelo a usar com o cérebro escolhido
#   --sem-servico          não instala nem reinicia o serviço do gateway
#   --sem-rotinas          não cria as rotinas agendadas
#   --sem-navegador        não instala o Chromium (carrossel não renderiza sem ele)
#
# Segredos NUNCA vão na linha de comando. Passe por variável de ambiente:
#   NAIMA_TELEGRAM_TOKEN   token do bot (do @BotFather)
#   NAIMA_CHAVE_CEREBRO    chave do OpenRouter ou da Anthropic, se for o caso
set -euo pipefail

AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HH="${HERMES_HOME:-$HOME/.hermes}"
NOME=""; TRAT=""; FUSO=""; WS=""; TGID=""; CEREBRO="manter"; MODELO=""
SERVICO=1; ROTINAS=1; NAVEGADOR=1

while [ $# -gt 0 ]; do
  case "$1" in
    --nome) NOME="$2"; shift 2 ;;
    --tratamento) TRAT="$2"; shift 2 ;;
    --fuso) FUSO="$2"; shift 2 ;;
    --workspace) WS="$2"; shift 2 ;;
    --telegram-id) TGID="$2"; shift 2 ;;
    --cerebro) CEREBRO="$2"; shift 2 ;;
    --modelo) MODELO="$2"; shift 2 ;;
    --sem-servico) SERVICO=0; shift ;;
    --sem-rotinas) ROTINAS=0; shift ;;
    --sem-navegador) NAVEGADOR=0; shift ;;
    -h|--help) sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "opção desconhecida: $1" >&2; exit 2 ;;
  esac
done

passo() { printf '\n== %s\n' "$*"; }
ok()    { printf '   ok  %s\n' "$*"; }
aviso() { printf '   !!  %s\n' "$*" >&2; }
morre() { printf '\nERRO: %s\n' "$*" >&2; exit 1; }

case "$(uname -s)" in Linux|Darwin) ;; *) morre "use Linux, macOS ou WSL2." ;; esac
[[ "$TGID" =~ ^[0-9]*$ ]] || morre "--telegram-id deve ser só números."
case "$CEREBRO" in chatgpt|openrouter|anthropic|manter) ;; *) morre "--cerebro inválido: $CEREBRO" ;; esac
export PATH="$HOME/.local/bin:$PATH"

# Reaproveita o que já foi informado numa instalação anterior.
ESTADO="$HH/naima.json"
ler_estado() { [ -f "$ESTADO" ] && python3 -c "import json,sys;print(json.load(open(sys.argv[1])).get(sys.argv[2],''))" "$ESTADO" "$1" 2>/dev/null || true; }
[ -n "$NOME" ] || NOME="$(ler_estado nome)"
[ -n "$TRAT" ] || TRAT="$(ler_estado tratamento)"
[ -n "$FUSO" ] || FUSO="$(ler_estado fuso)"; [ -n "$FUSO" ] || FUSO="America/Sao_Paulo"
[ -n "$WS" ] || WS="$(ler_estado workspace)"; [ -n "$WS" ] || WS="$HOME/naima"
[ -n "$NOME" ] || morre "informe --nome \"Nome do dono\"."
[ -n "$TRAT" ] || TRAT="${NOME%% *}"
case "$NOME$TRAT$FUSO$WS" in *'|'*|*$'\n'*) morre "nome, tratamento, fuso e pasta não podem ter '|' nem quebra de linha." ;; esac
WS="$(python3 -c 'import os,sys;print(os.path.abspath(os.path.expanduser(sys.argv[1])))' "$WS")"

# ---------------------------------------------------------------- 1. Hermes
passo "1/8 Hermes Agent"
if ! command -v hermes >/dev/null 2>&1; then
  livre_gb=$(df -Pk "$HOME" | awk 'NR==2{print int($4/1048576)}')
  [ "$livre_gb" -ge 5 ] || morre "só ${livre_gb} GB livres em $HOME; o Hermes precisa de uns 5 GB."
  args=(--non-interactive --skip-computer-use)
  if [ "$NAVEGADOR" = 0 ] || [ "$livre_gb" -lt 8 ]; then args+=(--skip-browser); aviso "Chromium não será instalado (use 'hermes pm install chromium' depois)."; fi
  tmp="$(mktemp)"; curl -fsSL https://hermes-agent.nousresearch.com/install.sh -o "$tmp" || morre "não consegui baixar o instalador oficial do Hermes."
  bash "$tmp" "${args[@]}" || morre "a instalação do Hermes falhou. Veja $HH/logs/install.log"
  rm -f "$tmp"; hash -r
fi
command -v hermes >/dev/null 2>&1 || morre "'hermes' não está no PATH. Abra um terminal novo e rode de novo."
ok "$(hermes --version 2>&1 | head -1)"
mkdir -p "$HH" "$HH/memories" "$HH/skills" "$HH/agent-hooks" "$HOME/.local/bin"

# ---------------------------------------------------------------- 2. cópia de segurança
passo "2/8 Cópia de segurança"
BK="$HH/backups/naima-$(date +%Y%m%d-%H%M%S)"; mkdir -p "$BK"
for f in SOUL.md config.yaml shell-hooks-allowlist.json; do [ -f "$HH/$f" ] && cp -p "$HH/$f" "$BK/" || true; done
[ -d "$HH/skills/jazz" ] && cp -rp "$HH/skills/jazz" "$BK/skills-jazz" || true
[ -f "$WS/AGENTS.md" ] && cp -p "$WS/AGENTS.md" "$BK/" || true
ok "$BK"

# ---------------------------------------------------------------- 3. núcleo
passo "3/8 Identidade, regras e espaço de trabalho"
preenche() { # preenche ORIGEM DESTINO
  NAIMA_N="$NOME" NAIMA_T="$TRAT" NAIMA_F="$FUSO" NAIMA_W="$WS" python3 - "$1" "$2" <<'PY'
import os, sys
t = open(sys.argv[1], encoding="utf-8").read()
for k, v in (("{{DONO_NOME}}", "NAIMA_N"), ("{{DONO_TRATAMENTO}}", "NAIMA_T"), ("{{FUSO}}", "NAIMA_F"), ("{{WORKSPACE}}", "NAIMA_W")):
    t = t.replace(k, os.environ[v])
open(sys.argv[2], "w", encoding="utf-8").write(t)
PY
}
preenche "$AQUI/nucleo/SOUL.md" "$HH/SOUL.md"; chmod 600 "$HH/SOUL.md"; ok "SOUL.md"

mkdir -p "$WS"
preenche "$AQUI/nucleo/workspace/AGENTS.md" "$WS/AGENTS.md"; ok "AGENTS.md em $WS"
# Dados do dono nunca são sobrescritos: só cria o que falta.
(cd "$AQUI/nucleo/workspace" && find . -type f ! -name AGENTS.md -print) | while IFS= read -r rel; do
  dest="$WS/${rel#./}"
  if [ ! -e "$dest" ]; then mkdir -p "$(dirname "$dest")"; preenche "$AQUI/nucleo/workspace/$rel" "$dest"; fi
done
ok "pastas do espaço de trabalho (o que já existia foi mantido)"

for m in MEMORY.md USER.md; do
  if [ ! -s "$HH/memories/$m" ]; then preenche "$AQUI/nucleo/memoria/$m" "$HH/memories/$m"; ok "memória inicial: $m"; else ok "memória $m mantida"; fi
done

# ---------------------------------------------------------------- 4. skills
passo "4/8 Skills da Jazz"
rm -rf "$HH/skills/jazz"; cp -r "$AQUI/skills/jazz" "$HH/skills/jazz"
find "$HH/skills/jazz" -name '*.sh' -exec chmod +x {} +
ok "$(find "$HH/skills/jazz" -name SKILL.md | wc -l | tr -d ' ') skills em $HH/skills/jazz"

# ---------------------------------------------------------------- 5. guarda e segredos
passo "5/8 Guarda de segredos"
install -m 700 "$AQUI/nucleo/agent-hooks/guarda.py" "$HH/agent-hooks/guarda.py"
install -m 755 "$AQUI/nucleo/bin/naima-segredo" "$HOME/.local/bin/naima-segredo"
GUARDA="$HH/agent-hooks/guarda.py"
python3 - "$HH/shell-hooks-allowlist.json" "$GUARDA" <<'PY'
import json, os, sys
arq, cmd = sys.argv[1], sys.argv[2]
try:
    d = json.load(open(arq))
    assert isinstance(d.get("approvals"), list)
except Exception:
    d = {"approvals": []}
if not any(a.get("event") == "pre_tool_call" and a.get("command") == cmd for a in d["approvals"] if isinstance(a, dict)):
    d["approvals"].append({"event": "pre_tool_call", "command": cmd})
json.dump(d, open(arq, "w"), indent=2)
os.chmod(arq, 0o600)
PY
touch "$HH/.env"; chmod 600 "$HH/.env"
[ -n "${NAIMA_TELEGRAM_TOKEN:-}" ] && { printf '%s\n' "$NAIMA_TELEGRAM_TOKEN" | naima-segredo guardar TELEGRAM_BOT_TOKEN >/dev/null; ok "token do bot guardado"; }
if [ -n "$TGID" ]; then
  naima-segredo guardar TELEGRAM_ALLOWED_USERS "$TGID" >/dev/null
  naima-segredo guardar TELEGRAM_HOME_CHANNEL "$TGID" >/dev/null
  ok "só o ID $TGID fala com a Naima"
fi
if [ -n "${NAIMA_CHAVE_CEREBRO:-}" ]; then
  case "$CEREBRO" in
    openrouter) printf '%s\n' "$NAIMA_CHAVE_CEREBRO" | naima-segredo guardar OPENROUTER_API_KEY >/dev/null; ok "chave do OpenRouter guardada" ;;
    anthropic)  printf '%s\n' "$NAIMA_CHAVE_CEREBRO" | naima-segredo guardar ANTHROPIC_API_KEY >/dev/null; ok "chave da Anthropic guardada" ;;
    *) aviso "NAIMA_CHAVE_CEREBRO ignorada: --cerebro $CEREBRO não usa chave." ;;
  esac
fi

# ---------------------------------------------------------------- 6. configuração
passo "6/8 Configuração do Hermes"
cfg() { hermes config set "$1" "$2" >/dev/null 2>&1 || hermes config set --force "$1" "$2" >/dev/null 2>&1 || aviso "não consegui ajustar $1"; }
cfg terminal.cwd "$WS"
cfg timezone "$FUSO"
cfg approvals.mode off
cfg approvals.cron_mode deny
cfg checkpoints.enabled true
cfg delegation.subagent_auto_approve true
cfg security.redact_secrets true
cfg security.tirith_enabled true
cfg hooks_auto_accept true
cfg memory.memory_char_limit 3000
cfg memory.user_char_limit 2000
cfg display.language pt
cfg stt.enabled true
cfg stt.provider local
cfg stt.local.model base
cfg stt.local.language pt
cfg hooks.pre_tool_call "[]"
case "$CEREBRO" in
  chatgpt)    cfg model.provider openai-codex; [ -n "$MODELO" ] || MODELO="gpt-5.6-luna"; cfg agent.reasoning_effort high ;;
  openrouter) cfg model.provider openrouter ;;
  anthropic)  cfg model.provider anthropic ;;
esac
[ -n "$MODELO" ] && cfg model.default "$MODELO"
ok "execução direta (sem cartão de aprovação), pontos de restauração, fuso $FUSO, tirith ligado"

# ---------------------------------------------------------------- 7. rotinas
passo "7/8 Rotinas agendadas"
if [ "$ROTINAS" = 1 ]; then
  ja="$(hermes cron list 2>/dev/null || true)"
  rotina() { # nome agenda prompt
    if printf '%s' "$ja" | grep -q -- "$1"; then ok "$1 já existe"; return; fi
    if hermes cron create "$2" "$3" --name "$1" --skill rotinas --deliver telegram --timezone "$FUSO" --workdir "$WS" >/dev/null 2>&1; then
      ok "$1 ($2)"
    else aviso "não consegui criar a rotina $1"; fi
  }
  rotina naima-bom-dia          "30 8 * * *"   "Execute a rotina bom-dia da skill rotinas."
  rotina naima-acompanhamento   "0 14 * * 1-5" "Execute a rotina acompanhamento da skill rotinas."
  rotina naima-revisao-semanal  "0 17 * * 5"   "Execute a rotina revisao-semanal da skill rotinas."
  rotina naima-saude            "0 */6 * * *"  "Execute a rotina saude da skill rotinas."
else ok "puladas (--sem-rotinas)"; fi

# ---------------------------------------------------------------- 8. serviço
passo "8/8 Serviço"
python3 - "$ESTADO" "$NOME" "$TRAT" "$FUSO" "$WS" <<'PY'
import json, sys, time
json.dump({"nome": sys.argv[2], "tratamento": sys.argv[3], "fuso": sys.argv[4], "workspace": sys.argv[5],
           "versao_naima": "1.1.0", "instalada_em": time.strftime("%Y-%m-%d %H:%M")}, open(sys.argv[1], "w"), ensure_ascii=False, indent=2)
PY
tem_bot=0; naima-segredo tem TELEGRAM_BOT_TOKEN >/dev/null 2>&1 && naima-segredo tem TELEGRAM_ALLOWED_USERS >/dev/null 2>&1 && tem_bot=1
if [ "$SERVICO" = 1 ] && [ "$tem_bot" = 1 ]; then
  hermes gateway install >/dev/null 2>&1 || aviso "não consegui registrar o serviço (rode 'hermes gateway install' para ver o erro)"
  hermes gateway restart >/dev/null 2>&1 || hermes gateway start >/dev/null 2>&1 || aviso "o serviço não subiu (veja 'hermes gateway status')"
  ok "gateway reiniciado"
elif [ "$tem_bot" = 0 ]; then
  aviso "sem token do bot ou ID do Telegram: o serviço não foi ligado."
else ok "serviço não alterado (--sem-servico)"; fi

echo
echo "== Conferência"
hermes hooks doctor 2>&1 | grep -E '✓|✗' | sed 's/^ */   /' || true
[ "$(grep -c '{{' "$HH/SOUL.md" "$WS/AGENTS.md" | awk -F: '{s+=$2} END{print s}')" = 0 ] && ok "nenhum campo por preencher" || aviso "sobrou campo {{...}} sem preencher"
printf '   cérebro: %s / %s\n' "$(hermes config get model.provider 2>/dev/null | tail -1)" "$(hermes config get model.default 2>/dev/null | tail -1)"

cat <<FIM

Naima instalada para $NOME.
  Espaço de trabalho : $WS
  Alma               : $HH/SOUL.md
  Cópia de segurança : $BK

Falta, se ainda não foi feito:
  - Cérebro por conta ChatGPT:  hermes auth add openai-codex
  - Testar no terminal:         hermes -z "quem é você?"
  - Teste de fogo:              python3 "$AQUI/teste-de-fogo/rodar.py"
  - No Telegram: mande "oi" para o bot e depois "pode começar a entrevista".
FIM
