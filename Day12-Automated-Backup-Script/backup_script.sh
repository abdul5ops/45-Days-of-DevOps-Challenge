#!/bin/bash

# Automated System Backup Script
# Day 12 of 45-Day DevOps Challenge

echo "=========================================="
echo "   AUTOMATED BACKUP SCRIPT"
echo "   Generated: $(date)"
echo "=========================================="
echo ""

# Configuration
SOURCE_DIR="$HOME/Desktop/45-Days-of-DevOps-Challenge"
BACKUP_DIR="$HOME/Desktop/Backups"
DATE_STAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_NAME="backup_${DATE_STAMP}.tar.gz"
RETENTION_DAYS=7

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "[*] Source Directory: $SOURCE_DIR"
echo "[*] Backup Directory: $BACKUP_DIR"
echo "[*] Retention Period: $RETENTION_DAYS days"
echo ""

# Check if source exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "[ERROR] Source directory not found: $SOURCE_DIR"
    exit 1
fi

echo "[*] Creating backup..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" . 2>/dev/null

if [ $? -eq 0 ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)
    echo "[SUCCESS] Backup created: $BACKUP_NAME"
    echo "[INFO] Backup size: $BACKUP_SIZE"
else
    echo "[ERROR] Backup failed!"
    exit 1
fi

echo ""
echo "[*] Cleaning up backups older than $RETENTION_DAYS days..."

# Delete old backups
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete 2>/dev/null

REMAINING=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)
echo "[INFO] Total backups retained: $REMAINING"

echo ""
echo "=========================================="
echo " BACKUP SUMMARY"
echo "=========================================="
echo "Backup File: $BACKUP_NAME"
echo "Location: $BACKUP_DIR"
echo "Status: SUCCESS"
echo "=========================================="

# List all backups
echo ""
echo "[*] Available backups:"
ls -lh "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
EOF
