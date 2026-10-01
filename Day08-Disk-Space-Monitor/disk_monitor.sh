#!/bin/bash

# Disk Space Monitor Script
# IT Support / DevOps Automation Project

THRESHOLD=80

echo "=========================================="
echo "   DISK SPACE MONITOR"
echo "   Generated: $(date)"
echo "=========================================="
echo ""

# Get disk usage for the root partition
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

echo "Current Disk Usage: ${DISK_USAGE}%"
echo "Alert Threshold: ${THRESHOLD}%"
echo ""

if [ "$DISK_USAGE" -ge "$THRESHOLD" ]; then
    echo "[WARNING] Disk space is critically low!"
    echo "[ACTION] Please clean up files or expand storage."
else
    echo "[OK] Disk space is within safe limits."
fi

echo ""
echo "--- Detailed Disk Usage ---"
df -h
echo ""
echo "=========================================="
