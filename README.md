# 🚀 Second Project DevOps - Kubernetes Edition

API Express.js conteneurisée avec pipeline CI/CD GitLab et déploiement Kubernetes.

## 📋 Architecture

```
┌─────────────┐     ┌──────────────────────────────────────────────────┐
│  Developer   │     │              GitLab CI/CD Pipeline               │
│  git push    │────▶│                                                  │
└─────────────┘     │  ┌──────┐  ┌───────┐  ┌──────┐  ┌────────────┐  │
                    │  │ Lint │─▶│ Build │─▶│ Test │─▶│   Deploy    │  │
                    │  └──────┘  └───┬───┘  └──────┘  └─────┬──────┘  │
                    └────────────────┼─────────────────────── ┼────────┘
                                     │                        │
                              ┌──────▼──────┐         ┌──────▼──────┐
                              │   GitLab    │         │ Kubernetes  │
                              │  Container  │         │   Cluster   │
                              │  Registry   │────────▶│  (2 pods)   │
                              └─────────────┘         └─────────────┘
```

## 🛠️ Stack Technique

| Composant | Technologie |
|-----------|------------|
| Runtime | Node.js 22 + Express 5 |
| Conteneurisation | Docker (multi-stage build) |
| CI/CD | GitLab CI/CD |
| Orchestration | Kubernetes |
| Sécurité | Trivy (scan vulnérabilités), Hadolint (lint Dockerfile) |
| Registry | GitLab Container Registry |

## 🚀 Démarrage rapide

### Prérequis
- Docker & Docker Compose
- Node.js 22+
- kubectl + Minikube (pour le déploiement local)

### Lancer en local

```bash
# Avec Docker Compose
docker compose up -d

# Sans Docker
npm install
npm start
```

L'API est accessible sur `http://localhost:3000`

### Endpoints

| Route | Description |
|-------|------------|
| `GET /` | Informations de l'application |
| `GET /health` | Liveness probe |
| `GET /ready` | Readiness probe |

## 📦 Pipeline CI/CD

Le pipeline GitLab comporte 5 stages :

1. **Lint** — Validation du Dockerfile (Hadolint) et des YAML (yamllint)
2. **Build** — Construction de l'image Docker et push vers le GitLab Container Registry
3. **Test** — Tests unitaires + test du conteneur (health check)
4. **Scan** — Scan de sécurité Trivy (vulnérabilités HIGH/CRITICAL)
5. **Deploy** — Déploiement Kubernetes (déclenché manuellement)

## ☸️ Déploiement Kubernetes

```bash
# Créer le namespace
kubectl apply -f k8s/namespace.yaml

# Déployer l'application
kubectl apply -f k8s/

# Vérifier le déploiement
kubectl get pods -n devops
kubectl get svc -n devops
```

### Manifestes

- `k8s/namespace.yaml` — Namespace `devops`
- `k8s/deployment.yaml` — 2 réplicas, rolling update, probes liveness/readiness
- `k8s/service.yaml` — ClusterIP sur le port 80 → 3000
- `k8s/ingress.yaml` — Ingress Nginx vers `second-project-devops.local`

## 🐳 Docker

L'image utilise un **multi-stage build** pour optimiser la taille :

- **Stage 1 (deps)** : Installation des dépendances avec `npm ci`
- **Stage 2 (production)** : Copie uniquement les fichiers nécessaires

Sécurité : exécution en tant qu'utilisateur `node` (non-root).

```bash
# Build manuel
docker build -t second-project-devops .

# Lancer
docker run -p 3000:3000 second-project-devops
```

## 📂 Structure du projet

```
second-project-devops/
├── .gitlab-ci.yml        # Pipeline CI/CD
├── Dockerfile            # Image Docker (multi-stage)
├── docker-compose.yaml   # Orchestration locale
├── .dockerignore         # Exclusions Docker
├── index.js              # API Express.js
├── package.json          # Dépendances Node.js
├── k8s/                  # Manifestes Kubernetes
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── README.md
```

## 👤 Auteur

**Mathieu** — [GitHub](https://github.com/Matfen2) | [GitLab](https://gitlab.com/Matfen2)
