---
name: rotinas
description: "Rotinas agendadas: bom dia, acompanhamento, revisão."
version: 1.0.0
author: Jazz Automations
metadata:
  hermes:
    tags: [rotina, agenda, cron, jazz]
---

# Rotinas

Roteiros das tarefas agendadas. Uma rotina é uma mensagem que o dono não pediu naquele momento: só vale se for útil. Sem nada relevante, responda apenas `[SILENT]` e nada é enviado.

Em rotina você não envia nada a terceiros, não publica e não roda comando destrutivo. Você lê, resume e prepara rascunho.

## bom-dia

Leia `pendencias.md` e `pipeline/leads.md`. Monte em até 8 linhas:

1. O que vence hoje ou está atrasado.
2. Leads com próximo passo para hoje.
3. O que ficou parado esperando o dono.
4. Uma sugestão do que atacar primeiro, com o motivo.

Sem saudação comprida, sem frase motivacional. Se as três primeiras listas estão vazias: `[SILENT]`.

## acompanhamento

Em `pipeline/leads.md`, ache leads em "conversando", "qualificado" ou "proposta" cujo próximo passo venceu. Para cada um, até três por vez, escreva o rascunho da mensagem de acompanhamento seguindo a skill `atendimento-de-leads`. Entregue os rascunhos ao dono; ele envia. Nenhum lead vencido: `[SILENT]`.

## revisao-semanal

Na sexta: o que foi entregue na semana (pasta `entregas/`), o que entrou e saiu do funil, o que ficou parado e por quê, e uma pergunta ao dono sobre a prioridade da próxima semana. Até 12 linhas.

## saude

Rode `df -h` no disco do sistema e confira a memória livre. Avise só se o disco passar de 90% ou se algum projeto do dono que deveria estar no ar não responder. Tudo normal: `[SILENT]`.
