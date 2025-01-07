#!/bin/bash
# deploy.sh

# Set variables
PROJECT_ID="dspl-24-poc"
ZONE="us-central1-a"
CLUSTER_NAME="dev-cluster"

# Configure Docker for GCP
echo "Configuring Docker for Google Container Registry..."
gcloud auth configure-docker

# Build and push Docker images
echo "Building and pushing Docker images..."

cd backend
docker build -t gcr.io/$PROJECT_ID/backend:latest .
docker push gcr.io/$PROJECT_ID/backend:latest
cd ..

cd frontend
docker build -t gcr.io/$PROJECT_ID/frontend:latest .
docker push gcr.io/$PROJECT_ID/frontend:latest
cd ..

# Connect to GKE cluster
echo "Connecting to GKE cluster..."
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID

# Create namespace if it doesn't exist
kubectl create namespace app --dry-run=client -o yaml | kubectl apply -f -

# Apply Kubernetes configurations
echo "Applying Kubernetes configurations..."
kubectl apply -f k8s/ -n app

# Wait for deployments to be ready
echo "Waiting for deployments to be ready..."
kubectl rollout status deployment/backend -n app
kubectl rollout status deployment/frontend -n app

echo "Deployment completed successfully!"