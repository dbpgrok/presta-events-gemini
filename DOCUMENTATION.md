# 📔 Journal de Bord & Architecture - PrestaChrono

Ce document retrace les choix technologiques, l'architecture globale et l'historique de déploiement de la plateforme **PrestaChrono**, une solution de réservation d'événements en temps réel dédiée aux CHR (Cafés, Hôtels, Restaurants).

---

## 🛠️ Choix d'Architecture : 100% Cloud & "Zero Cost"

Pour ce projet, l'objectif était d'avoir une infrastructure robuste, performante, rapide à déployer et **intégralement gratuite** sans dépendre de serveurs tiers (comme Render).

│                  GITHUB CODESPACES                     │ <--- Environnement de Dev (Navigateur)
└──────────────────────────┬─────────────────────────────┘
│ git push
▼
┌────────────────────────────────────────────────────────┐
│                   GITHUB REPOSITORY                    │ <--- Stockage du Code Source
└──────────────────────────┬─────────────────────────────┘
│ Déclenchement Automatique
▼
┌────────────────────────────────────────────────────────┐
│                     GITHUB ACTIONS                     │ <--- Robot compilateur (Build Next.js)
└──────────────────────────┬─────────────────────────────┘
│ Génère l'export HTML/CSS/JS
▼
┌────────────────────────────────────────────────────────┐
│                      GITHUB PAGES                      │ <--- Hébergement Statique Public Gratuit
└──────────────────────────┬─────────────────────────────┘
│ Échange de Données Temps Réel (WebSockets)
▼
┌────────────────────────────────────────────────────────┐
│                   SUPABASE (POSTGRES)                  │ <--- Base de données externe

### La Stack Technique
*   **Framework :** Next.js 15 (App Router) avec TypeScript.
*   **Styling :** Tailwind CSS pour une interface B2B sombre et minimaliste.
*   **Icônes :** Lucide-react.
*   **Hébergement :** GitHub Pages via compilation statique (`output: 'export'`).
*   **Base de données & Temps Réel :** Supabase (PostgreSQL + WebSockets).

---

## 📜 Historique des Étapes de Réalisation

### 🏗️ Étape 1 : Initialisation & Pipeline CI/CD (GitHub Actions)
*   **Objectif :** Configurer le projet Next.js et automatiser le déploiement sur GitHub Pages.
*   **Réalisation :** 
    *   Création d'un script d'automatisation globale (`setup.sh`).
    *   Configuration de `next.config.mjs` pour forcer l'export statique (`output: 'export'`) et désactiver l'optimisation par défaut des images (incompatible avec l'hébergement statique pur).
    *   Mise en place du workflow GitHub Actions dans `.github/workflows/deploy.yml` qui compile et pousse le dossier `/out` vers la branche d'hébergement GitHub Pages à chaque `git push` sur `main`.

### 🎨 Étape 2 : Catalogue des Prestations (Page d'accueil)
*   **Objectif :** Créer une interface utilisateur minimaliste, élégante et axée sur l'expérience B2B pour les gérants d'établissements.
*   **Réalisation :** 
    *   Développement de la page d'accueil dans `src/app/page.tsx` avec un thème ultra-sombre (`bg-neutral-950`).
    *   Modélisation des **5 offres événementielles phares** :
        1.  *DJ Set Premium*
        2.  *Mixologie & Barmaid*
        3.  *Stand Coco & Fleurs Tropicales*
        4.  *Stand Culinaire Thématique*
        5.  *Showcases Privés*
    *   Gestion de l'état dynamique de sélection : cliquer sur une carte affiche instantanément un encart d'action pour accéder au futur calendrier.
    *   Mise à jour des variables de style globales dans `src/app/globals.css`.

---

## 🚀 Prochaines Étapes prévues
1.  **Modélisation Supabase :** Création des tables PostgreSQL (Établissements, Prestations, Réservations).
2.  **Moteur Calendrier :** Intégration d'un calendrier et connexion aux fonctionnalités temps réel de Supabase.
