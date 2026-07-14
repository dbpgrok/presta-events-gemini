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
