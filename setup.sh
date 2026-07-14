#!/bin/bash

echo "🚀 Début de l'initialisation du projet Next.js 100% GitHub..."

# 1. Initialisation de Next.js avec les flags pour éviter les questions interactives
# On utilise les recommandations : TS, Tailwind, src/, App Router, et ESLint
npx create-next-app@latest . \
  --typescript \
  --tailwind \
  --src-dir \
  --app \
  --eslint \
  --import-alias "@/*" \
  --use-npm

echo "📦 Installation des dépendances additionnelles..."
# Lucide-react pour des icônes minimalistes et élégantes
npm install lucide-react

echo "⚙️ Configuration de next.config.mjs pour l'export statique..."
# On réécrit le fichier de configuration pour activer l'export HTML statique requis par GitHub Pages
cat << 'EOF' > next.config.mjs
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  images: {
    unoptimized: true,
  },
  // Permet de gérer le chemin de base si ton dépôt n'est pas un dépôt "user" principal (ex: https://pseudo.github.io/nom-du-repo/)
  basePath: process.env.NODE_ENV === 'production' ? `/${process.env.GITHUB_REPOSITORY_NAME}` : '',
};

export default nextConfig;
EOF

echo "📁 Création de la structure des dossiers et du Workflow GitHub Actions..."
# Création du dossier pour le script de déploiement automatique
mkdir -p .github/workflows

# Création du fichier de déploiement GitHub Actions
cat << 'EOF' > .github/workflows/deploy.yml
name: Deploy Next.js to GitHub Pages

on:
  push:
    branches: ["main"]

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: "20"
      - name: Setup Pages
        uses: actions/configure-pages@v4
      - name: Install dependencies
        run: npm ci
      - name: Build Next.js
        run: GITHUB_REPOSITORY_NAME=${{ github.event.repository.name }} npm run build
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./out

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOF

echo "🧹 Nettoyage et premier commit..."
# Ajout de tous les fichiers générés à Git
git add .
git commit -m "Initialisation automatique Next.js + GitHub Pages"

# Push automatique vers la branche principale
git push origin main

echo "🎯 Configuration terminée avec succès !"
echo "💡 Rappel : N'oublie pas d'activer 'GitHub Actions' dans Settings > Pages > Source sur l'interface GitHub."