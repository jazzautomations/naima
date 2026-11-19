#!/usr/bin/env python3
"""Guarda da Naima: hook pre_tool_call do Hermes.

Barra, antes de a ferramenta rodar, qualquer tentativa de LER segredo:
arquivos de credencial, .env e despejo de variáveis de ambiente.
A regra não depende de o modelo obedecer ao prompt.

Entrada: JSON no stdin (tool_name, tool_input). Saída: JSON de bloqueio ou nada.
"""
import json
import re
import sys

# Credenciais que nenhuma ferramenta deve tocar diretamente.
COFRE = re.compile(
    r"\.hermes(?:/profiles/[^/\s\"']+)?/(?:\.env|auth\.json)"
    r"|\.codex/auth\.json"
    r"|/\.ssh/(?:id_[a-z0-9_]+|[^\s\"']*_key)(?!\.pub)(?![\w.])"
    r"|\.aws/credentials|\.oci/[^\s\"']*\.pem|\.netrc|\.git-credentials"
    r"|shell-hooks-allowlist\.json|agent-hooks/guarda\.py",
    re.I,
)
# Qualquer .env que não seja modelo.
ENV_ARQ = re.compile(r"(?<![\w-])\.env(?!\.(?:example|exemplo|sample|template|dist)\b)(?:\.[\w-]+)?(?![\w/])", re.I)
# Despejo do ambiente do processo.
ENV_DUMP = re.compile(
    r"(?:^|[;&|(`]|\$\()\s*(?:printenv|env|export\s+-p|declare\s+-x|set)\s*(?:$|[|>;&)])"
    r"|/proc/(?:self|\d+)/environ"
    r"|os\.environ(?!\.get\(|\[)"
    r"|process\.env(?![.\[])",
    re.I | re.M,
)
LEITORES = {"terminal", "read_file", "search_files", "execute_code", "process_manage",
            "browser_exec", "vision_analyze"}
MSG = ("Bloqueado pela guarda: isso leria um segredo. Segredo não é lido nem exibido. "
       "Use `naima-segredo tem NOME` para conferir se existe, `naima-segredo listar` para ver "
       "os nomes e `naima-segredo guardar NOME` para gravar. Diga ao dono o que foi bloqueado.")


def bloquear(motivo):
    print(json.dumps({"action": "block", "message": f"{MSG} ({motivo})"}, ensure_ascii=False))
    sys.exit(0)


def main():
    try:
        ev = json.load(sys.stdin)
    except Exception:
        return
    if ev.get("hook_event_name") != "pre_tool_call":
        return
    tool = ev.get("tool_name") or ""
    entrada = ev.get("tool_input")
    if not isinstance(entrada, dict):
        return
    texto = json.dumps(entrada, ensure_ascii=False)
    cmd = str(entrada.get("command") or "") if tool == "terminal" else ""

    # O utilitário de segredos é o único caminho permitido, e só ele sozinho na linha.
    if cmd and re.fullmatch(r"\s*naima-segredo\s+(?:tem|listar|guardar|remover)\b[^;&|`$<>]*", cmd):
        return
    if tool in LEITORES or tool in {"write_file", "patch"}:
        if COFRE.search(texto):
            bloquear("arquivo de credencial")
    if tool in LEITORES:
        if ENV_ARQ.search(texto):
            bloquear("arquivo .env")
        if tool in {"terminal", "execute_code"} and ENV_DUMP.search(cmd or texto):
            bloquear("despejo de variáveis de ambiente")


if __name__ == "__main__":
    main()
