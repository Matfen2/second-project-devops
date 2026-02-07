
# ---- Stage 1: Dependencies ----
FROM node:25-alpine3.23 AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# ---- Stage 2: Production ----
FROM node:25-alpine3.23 AS production
LABEL maintainer="Matfen2"
LABEL description="Second Project DevOps - Kubernetes Edition"

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY package*.json ./
COPY index.js ./

# Sécurité : utilisateur non-root
USER node

# Variables d'environnement
ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

# Healthcheck intégré
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["node", "index.js"]