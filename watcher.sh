#!/bin/bash
# ─────────────────────────────────────────────────────────────────
# Expad Roadmap — Watcher automático
# Detecta mudanças nos arquivos e publica no GitHub Pages.
# Iniciado automaticamente pelo launchd no login do macOS.
# ─────────────────────────────────────────────────────────────────

SITE="$HOME/Desktop/Expad 2.0/expad-roadmap-site"
INTERNAL="$HOME/Desktop/Expad 2.0/expad-roadmap-2026.html"
LOG="$SITE/watcher.log"
INTERVAL=86400  # verifica uma vez por dia (24h)
DEBOUNCE=10     # segundos de espera após detectar mudança (evita publicações duplas)

log() {
  echo "[$(date '+%d/%m/%Y %H:%M:%S')] $1" >> "$LOG"
}

log "==============================="
log "Watcher iniciado (PID $$)"
log "Monitorando: public.html, projects.json, expad-roadmap-2026.html"

# Inicializa timestamps (sem publicar na primeira leitura)
LAST_PUBLIC=$(stat -f %m "$SITE/public.html" 2>/dev/null || echo "0")
LAST_JSON=$(stat -f %m "$SITE/projects.json" 2>/dev/null || echo "0")
LAST_INTERNAL=$(stat -f %m "$INTERNAL" 2>/dev/null || echo "0")

while true; do
  sleep $INTERVAL

  CUR_PUBLIC=$(stat -f %m "$SITE/public.html" 2>/dev/null || echo "0")
  CUR_JSON=$(stat -f %m "$SITE/projects.json" 2>/dev/null || echo "0")
  CUR_INTERNAL=$(stat -f %m "$INTERNAL" 2>/dev/null || echo "0")

  CHANGED=0

  if [ "$CUR_PUBLIC" != "$LAST_PUBLIC" ]; then
    log "Mudança detectada: public.html"
    CHANGED=1
  fi
  if [ "$CUR_JSON" != "$LAST_JSON" ]; then
    log "Mudança detectada: projects.json"
    CHANGED=1
  fi
  if [ "$CUR_INTERNAL" != "$LAST_INTERNAL" ]; then
    log "Mudança detectada: expad-roadmap-2026.html"
    CHANGED=1
  fi

  if [ $CHANGED -eq 1 ]; then
    log "Aguardando ${DEBOUNCE}s (debounce)..."
    sleep $DEBOUNCE

    # Atualiza timestamps antes de publicar
    LAST_PUBLIC=$(stat -f %m "$SITE/public.html" 2>/dev/null || echo "0")
    LAST_JSON=$(stat -f %m "$SITE/projects.json" 2>/dev/null || echo "0")
    LAST_INTERNAL=$(stat -f %m "$INTERNAL" 2>/dev/null || echo "0")

    log "Publicando..."
    bash "$SITE/publicar.sh" >> "$LOG" 2>&1
    log "Publicação concluída."
  fi
done
