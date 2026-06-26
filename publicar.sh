#!/bin/bash

echo "🚀 Publicando roadmap Expad..."

SITE=~/Desktop/Expad\ 2.0/expad-roadmap-site

# Roadmap público → raiz do site (roadmap.expad.co/)
cp "$SITE/public.html" "$SITE/index.html"

# Dashboard interno → /interno (roadmap.expad.co/interno)
cp ~/Desktop/Expad\ 2.0/expad-roadmap-2026.html "$SITE/interno.html"

# Se existe projects.json em Downloads (gerado pelo botão "Exportar público"),
# copia para o site — isso atualiza quais projetos aparecem no roadmap público
if [ -f ~/Downloads/projects.json ]; then
  cp ~/Downloads/projects.json "$SITE/projects.json"
  rm ~/Downloads/projects.json
  echo "✓ projects.json atualizado (visibilidade pública sincronizada)"
else
  echo "ℹ️  Sem projects.json novo — usando o anterior (ou clique 'Exportar público' no dashboard)"
fi

# Entra na pasta e publica
cd "$SITE"
git add .
git commit -m "update: roadmap $(date '+%d/%m/%Y %H:%M')"
git pull origin gh-pages --rebase
git push origin gh-pages

echo "✅ Publicado! roadmap.expad.co (público) e roadmap.expad.co/interno (dashboard)"
