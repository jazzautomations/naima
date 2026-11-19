#!/usr/bin/env bash
# Renderiza cada NN.html de uma pasta em NN.png (1080x1350).
# Uso: renderizar.sh PASTA [LARGURA] [ALTURA]
set -euo pipefail
dir="${1:?uso: renderizar.sh PASTA [LARGURA] [ALTURA]}"; w="${2:-1080}"; h="${3:-1350}"
nav=""
for c in chromium chromium-browser google-chrome google-chrome-stable brave-browser; do
  command -v "$c" >/dev/null 2>&1 && { nav="$c"; break; }
done
if [ -z "$nav" ]; then
  nav="$(find "$HOME/.cache/ms-playwright" -type f \( -name chrome -o -name headless_shell \) 2>/dev/null | head -1 || true)"
fi
[ -n "$nav" ] || { echo "Nenhum navegador encontrado. Instale o chromium (apt install chromium) ou rode: hermes pm install chromium" >&2; exit 3; }
cd "$dir"; n=0
for f in [0-9]*.html; do
  [ -e "$f" ] || { echo "nenhum NN.html em $dir" >&2; exit 4; }
  out="${f%.html}.png"
  "$nav" --headless=new --no-sandbox --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size="$w,$h" --virtual-time-budget=4000 --screenshot="$PWD/$out" "file://$PWD/$f" >/dev/null 2>&1
  [ -s "$out" ] || { echo "falhou: $f" >&2; exit 5; }
  n=$((n+1)); echo "$out"
done
echo "$n cards renderizados em $PWD"
