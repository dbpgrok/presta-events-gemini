/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  images: {
    unoptimized: true,
  },
  basePath: process.env.NODE_ENV === 'production' ? `/${process.env.GITHUB_REPOSITORY_NAME}` : '',
  
  // Évite les plantages mémoire (OOM) en désactivant le multi-threading lourd
  experimental: {
    workerThreads: false,
    cpus: 1
  },
  
  // Ignore les étapes secondaires lourdes durant la compilation sur le serveur
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  }
};

export default nextConfig;
