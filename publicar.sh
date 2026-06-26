#!/bin/bash

echo "🚀 Publicando roadmap Expad..."

# Copia o arquivo mais recente
cp ~/Desktop/Expad\ 2.0/expad-roadmap-2026.html ~/Desktop/Expad\ 2.0/expad-roadmap-site/index.html

# Entra na pasta do repositório
cd ~/Desktop/Expad\ 2.0/expad-roadmap-site

# Commit e push
git add .
git commit -m "update: roadmap $(date '+%d/%m/%Y %H:%M')"
git pull origin gh-pages --rebase
git push origin gh-pages

echo "✅ Publicado! Acesse: https://roadmap.expad.co"
