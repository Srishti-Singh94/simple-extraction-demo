#!/bin/bash

K8S_DIR="k8s"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="cleanup-$TIMESTAMP.log"
BACKUP_FILE="k8s-backup-$TIMESTAMP.zip"

echo "🧹 You are about to delete all Kubernetes resources defined in '$K8S_DIR/'"
echo "📦 A backup of the $K8S_DIR folder will be created as: $BACKUP_FILE"
echo "📜 A log of deleted resources will be saved to: $LOG_FILE"

# Ask for dry run first
read -p "🔍 Would you like to do a dry run first? (y/n): " dryrun
if [ "$dryrun" == "y" ]; then
    echo "🔎 Performing dry-run (nothing will be deleted)..."
    kubectl delete -f "$K8S_DIR/" --dry-run=client -o yaml | tee "$LOG_FILE"
    echo "✅ Dry run complete. Review $LOG_FILE."
    exit 0
fi

# Ask for confirmation
read -p "⚠️ Are you sure you want to DELETE all resources now? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "❌ Cleanup aborted."
    exit 1
fi

# Step 1: Backup
echo "📦 Backing up '$K8S_DIR/' to $BACKUP_FILE..."
zip -r "$BACKUP_FILE" "$K8S_DIR" > /dev/null
echo "✅ Backup complete."

# Step 2: Delete resources and log output
echo "⏳ Deleting Kubernetes resources..."
kubectl delete -f "$K8S_DIR/" | tee "$LOG_FILE"

echo "✅ All resources deleted."
echo "📁 Log saved to: $LOG_FILE"
echo "🗃️ Backup saved to: $BACKUP_FILE"
