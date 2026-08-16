# Go - Minikube Lab

A Go HTTP application running on Kubernetes (Minikube cluster), with multi-stage Docker builds and automated container publishing to GitHub Container Registry (GHCR).

## Features

- Go HTTP server with health checks (/healthz) and pod name inspection (/hostname)

- Kubernetes Deployment manifest with liveness and readiness probes

- Kubernetes NodePort Service manifest

- Automated Docker build and push to GHCR via GitHub Actions

## Endpoints

- GET / - Root endpoint

- GET /healthz - Liveness and readiness probe endpoint

- GET /hostname - Returns the current pod hostname

## Minikube Deployment

### Start Minikube

```bash
minikube start
```

### Apply Kubernetes manifests

```bash
kubectl apply -f k8s/
```

### Test via Terminal Loop

```bash
while true; do curl -s $(minikube service go-k8s-service --url)/hostname; echo ""; sleep 1; done
```

#### Output: cycle through 3 replica pod names

```code
Pod Hostname: go-k8s-deployment-8f47d4c55-pgn47

Pod Hostname: go-k8s-deployment-8f47d4c55-sd8jq

Pod Hostname: go-k8s-deployment-8f47d4c55-8qbx8

Pod Hostname: go-k8s-deployment-8f47d4c55-sd8jq

Pod Hostname: go-k8s-deployment-8f47d4c55-8qbx8

Pod Hostname: go-k8s-deployment-8f47d4c55-sd8jq
```