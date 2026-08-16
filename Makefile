.PHONY: help run build-docker minikube-start minikube-build deploy-k8s logs clean

# Variable definitions
APP_NAME := go-k8s
K8S_DIR := k8s

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

run: ## Run the Go app locally
	go run ./cmd/app

build-docker: ## Build Docker image locally
	docker build -t $(APP_NAME):local .

minikube-start: ## Start Minikube cluster
	minikube start

minikube-build: ## Build Docker image directly inside Minikube's Docker daemon
	eval $$(minikube docker-env) && docker build -t $(APP_NAME):local .

deploy-k8s: ## Apply all Kubernetes manifests in the k8s directory
	kubectl apply -f $(K8S_DIR)/

status-k8s: ## Check status of all Kubernetes resources for the app
	kubectl get all -l app=$(APP_NAME)

logs: ## Tail logs for all pods in the deployment
	kubectl logs -l app=$(APP_NAME) -f --tail=50

url: ## Get the Minikube service URL
	minikube service $(APP_NAME)-service --url

clean: ## Delete Kubernetes resources created by the manifests
	kubectl delete -f $(K8S_DIR)/