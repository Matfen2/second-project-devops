FROM node:25-alpine3.23

WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste du code source
COPY . .

# Exposer le port Vite
USER node
EXPOSE 3000
ENV NODE_ENV=production

# Lancer l'app en mode prod
CMD ["npm", "start"]