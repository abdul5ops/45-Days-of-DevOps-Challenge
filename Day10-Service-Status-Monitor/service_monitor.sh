#!/bin/bash

# Service Status Monitor Script
# Day 10 of 45-Day DevOps Challenge

echo "=========================================="
echo "   SERVICE STATUS MONITOR"
echo "   Generated: $(date)"
echo "=========================================="
echo ""

SERVICES=("ssh" "cron" "network" "docker")
LOG_FILE="service_status_$(date +%Y-%m-%d_%H-%M-%S).log"

DOWN_COUNT=0
UP_COUNT=0

for SERVICE in "${SERVICES[@]}"; do
    case $SERVICE in
        "ssh")
            echo "[✓] $SERVICE is RUNNING (simulated)" | tee -a "$LOG_FILE"
            ((UP_COUNT++))
            ;;
        "cron")
            echo "[✓] $SERVICE is RUNNING (simulated)" | tee -a "$LOG_FILE"
            ((UP_COUNT++))
            ;;
        "network")
            echo "[✓] $SERVICE is RUNNING (simulated)" | tee -a "$LOG_FILE"
            ((UP_COUNT++))
            ;;
        "docker")
            echo "[✗] $SERVICE is NOT RUNNING (simulated)" | tee -a "$LOG_FILE"
            ((DOWN_COUNT++))
            ;;
    esac
done

echo "" | tee -a "$LOG_FILE"
echo "==========================================" | tee -a "$LOG_FILE"
echo "SUMMARY:" | tee -a "$LOG_FILE"
echo "  Services UP: $UP_COUNT" | tee -a "$LOG_FILE"
echo "  Services DOWN: $DOWN_COUNT" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

if [ "$DOWN_COUNT" -gt 0 ]; then
    echo "[WARNING] $DOWN_COUNT service(s) are down!" | tee -a "$LOG_FILE"
    echo "STATUS: WARNING" | tee -a "$LOG_FILE"
else
    echo "[OK] All services are running normally." | tee -a "$LOG_FILE"
    echo "STATUS: HEALTHY" | tee -a "$LOG_FILE"
fi

echo "==========================================" | tee -a "$LOG_FILE"
echo ""
echo "Report saved to: $LOG_FILE"
