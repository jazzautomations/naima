#!/usr/bin/env bash
# Cria o perfil "atendente": memória própria, sem terminal e sem execução de código.
# Uso: bash criar.sh   (depois de instalar a Naima)
set -euo pipefail
AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; HH="${HERMES_HOME:-$HOME/.hermes}"
export PATH="$HOME/.local/bin:$PATH"
[ -f "$HH/naima.json" ] || { echo "instale a Naima antes (instalar.sh)." >&2; exit 1; }
NOME="$(python3 -c "import json,sys;print(json.load(open(sys.argv[1]))['nome'])" "$HH/naima.json")"
WS="$(python3 -c "import json,sys;print(json.load(open(sys.argv[1]))['workspace'])" "$HH/naima.json")"
PD="$HH/profiles/atendente"
[ -d "$PD" ] || hermes profile create atendente --no-skills --no-alias --description "Atendimento de leads de $NOME" >/dev/null
mkdir -p "$PD/skills/jazz" "$WS/atendente"
NAIMA_N="$NOME" python3 -c "import os,sys;open(sys.argv[2],'w').write(open(sys.argv[1]).read().replace('{{DONO_NOME}}',os.environ['NAIMA_N']))" "$AQUI/SOUL.md" "$PD/SOUL.md"
rm -rf "$PD/skills/jazz/atendimento-de-leads"; cp -r "$HH/skills/jazz/atendimento-de-leads" "$PD/skills/jazz/"
[ -e "$WS/atendente/ofertas.md" ] || cp "$WS/dono/ofertas.md" "$WS/atendente/ofertas.md"
[ -e "$WS/atendente/voz.md" ] || cp "$WS/dono/voz.md" "$WS/atendente/voz.md"
[ -e "$WS/atendente/leads.md" ] || printf '# Funil do atendente\n' > "$WS/atendente/leads.md"
hermes -p atendente config set terminal.cwd "$WS/atendente" >/dev/null
hermes -p atendente config set approvals.mode manual >/dev/null
# A mesma guarda de segredos da Naima vale para o atendente.
G="$HH/agent-hooks/guarda.py"
hermes -p atendente config set hooks.pre_tool_call "[{\"command\": \"$G\", \"timeout\": 10, \"fail_closed\": true}]" >/dev/null
printf '{"approvals": [{"event": "pre_tool_call", "command": "%s"}]}\n' "$G" > "$PD/shell-hooks-allowlist.json"; chmod 600 "$PD/shell-hooks-allowlist.json"
for plat in cli telegram whatsapp; do
  hermes -p atendente tools disable terminal code_execution browser computer_use delegation cronjob image_gen tts connections --platform "$plat" >/dev/null 2>&1 || true
done
echo "Perfil atendente criado em $PD"
echo "Pasta do atendente: $WS/atendente (ofertas.md e voz.md são cópias; atualize quando mudar o original)"
hermes -p atendente tools list --platform cli 2>/dev/null | grep -E 'enabled|disabled' | sed 's/^/  /' | head -24
