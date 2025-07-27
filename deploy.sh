#!/bin/bash

K8S_DIR="k8s"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="deploy-$TIMESTAMP.log"
BACKUP_FILE="k8s-backup-before-deploy-$TIMESTAMP.zip"

# STEP 0: Check if Minikube is running
echo "🚦 Checking Minikube status..."

if ! minikube status | grep -q "host: Running"; then
    echo "⚠️ Minikube is not running. Attempting to start it..."
    minikube start
    if [ $? -ne 0 ]; then
        echo "❌ Failed to start Minikube. Please check manually."
        exit 1
    fi
    echo "✅ Minikube started."
else
    echo "✅ Minikube is already running."
fi

# Optional: Wait a few seconds for stability
sleep 5

# STEP 1: Backup k8s folder
echo "📦 Backing up '$K8S_DIR/' to: $BACKUP_FILE"
zip -r "$BACKUP_FILE" "$K8S_DIR" > /dev/null
echo "✅ Backup complete."

# STEP 2: Validate YAML files before deploying
echo "🔍 Validating Kubernetes YAML manifests..."
for file in $(find "$K8S_DIR" -type f -name "*.yaml" -o -name "*.yml"); do
    echo "⏳ Validating $file ..."
    kubectl apply --dry-run=client -f "$file" > /dev/null
    if [ $? -ne 0 ]; then
        echo "❌ Error: Validation failed for $file"
        echo "🚫 Deployment aborted!"
        exit 1
    fi
done
echo "✅ All manifests validated successfully."

# STEP 3: Deploy
echo "🚀 Deploying all Kubernetes resources from '$K8S_DIR/'..."
kubectl apply -f "$K8S_DIR/" | tee "$LOG_FILE"

# STEP 4: /etc/hosts Reminder
echo "🔧 Reminder: Add this to your /etc/hosts if not present:"
echo "127.0.0.1 demo.local"
echo "✅ Deployment finished. Logs saved to $LOG_FILE"
