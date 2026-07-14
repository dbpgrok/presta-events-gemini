#!/bin/bash

echo "🔑 Configuration automatisée des variables d'environnement Supabase..."

# Demander à l'utilisateur de saisir ses clés Supabase directement dans le terminal
read -p "Entrez votre URL de projet Supabase (ex: https://xxxx.supabase.co) : " SUPABASE_URL
read -p "Entrez votre clé publique Supabase (anon key) : " SUPABASE_ANON_KEY

if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
    echo "❌ Erreur : L'URL et la clé ne peuvent pas être vides. Relancez le script."
    exit 1
fi

# 1. Création locale du fichier .env.local (sécurisé, ignoré par Git)
cat << EOF > .env.local
NEXT_PUBLIC_SUPABASE_URL=$SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
EOF
echo "✅ Fichier .env.local créé avec succès pour votre Codespace !"

# 2. Mise à jour du workflow GitHub Actions (.github/workflows/deploy.yml)
# Nous injectons les variables directement lors de l'étape de compilation (npm run build)
# pour que le site statique déployé puisse communiquer avec votre Supabase.
cat << EOF > .github/workflows/deploy.yml
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
        env:
          NEXT_PUBLIC_SUPABASE_URL: $https://yqzeibtmujnkrwkcvqni.supabase.co
          NEXT_PUBLIC_SUPABASE_ANON_KEY: $sb_publishable_4YOKLRjdrytpUQ_heTKi7g_v-Rja5tS
        run: GITHUB_REPOSITORY_NAME=\${{ github.event.repository.name }} npm run build
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./out

  deploy:
    environment:
      name: github-pages
      url: \${{ deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOF
echo "✅ Script de déploiement GitHub Actions mis à jour avec vos clés !"

# 3. Mise à jour finale du journal de bord
cat << 'EOF' >> DOCUMENTATION.md

### 🔑 Étape 5 : Variables d'environnement & Sécurisation
* **Objectif :** Connecter de manière sécurisée et automatisée l'environnement de build de GitHub avec notre instance de base de données Supabase.
* **Réalisation :** * Automatisation via un script de capture d'inputs (`step6_env_config.sh`).
    * Création locale du fichier de configuration `.env.local`.
    * Injection des variables système `NEXT_PUBLIC_SUPABASE_URL` et `NEXT_PUBLIC_SUPABASE_ANON_KEY` lors de l'étape de compilation statique (Build) dans le workflow GitHub Actions.
EOF
echo "📝 Journal de bord DOCUMENTATION.md mis à jour !"

# 4. Git Push
echo "🧹 Enregistrement des configurations et Push sur GitHub..."
git add .
git commit -m "Config: Variables d'environnement automatisées dans le workflow"
git push origin main

echo "🎯 Étape complétée avec succès ! Votre site est en train d'être compilé et déployé avec vos accès Supabase."