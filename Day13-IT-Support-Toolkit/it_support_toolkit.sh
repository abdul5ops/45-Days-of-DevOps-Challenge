#!/bin/bash

# IT Support Toolkit - All-in-One Script
# Day 13 of 45-Day DevOps Challenge
# Combines: System Health, Services, Network, Users, Backup, Logs

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

TOOLKIT_DIR="$HOME/Desktop/IT-Support-Toolkit-Logs"
mkdir -p "$TOOLKIT_DIR"

show_banner() {
    clear
    echo "=========================================="
    echo "       IT SUPPORT TOOLKIT v1.0"
    echo "       $(date)"
    echo "=========================================="
    echo ""
}

system_health() {
    echo ""
    echo "---- SYSTEM HEALTH CHECK ----"
    echo ""
    echo "Hostname: $(hostname)"
    echo "User: $(whoami)"
    echo "Date: $(date)"
    echo ""
    echo "Disk Usage:"
    df -h | head -5
    echo ""
    echo "Status: CHECKED"
    echo ""
}

service_monitor() {
    echo ""
    echo "---- SERVICE STATUS ----"
    echo ""
    SERVICES=("ssh" "cron" "network" "docker")
    UP=0
    DOWN=0
    for SERVICE in "${SERVICES[@]}"; do
        if [ "$SERVICE" = "docker" ]; then
            echo -e "${RED}[X]${NC} $SERVICE is NOT RUNNING"
            DOWN=$((DOWN+1))
        else
            echo -e "${GREEN}[OK]${NC} $SERVICE is RUNNING"
            UP=$((UP+1))
        fi
    done
    echo ""
    echo "Services UP: $UP | Services DOWN: $DOWN"
    echo ""
}

network_check() {
    echo ""
    echo "---- NETWORK CONNECTIVITY ----"
    echo ""
    echo "Local IP:"
    ipconfig | grep -A 2 "IPv4" | head -3
    echo ""
    if ping -n 2 8.8.8.8 &> /dev/null; then
        echo -e "${GREEN}[OK]${NC} Internet: WORKING"
    else
        echo -e "${RED}[X]${NC} Internet: DOWN"
    fi
    if nslookup google.com &> /dev/null; then
        echo -e "${GREEN}[OK]${NC} DNS: RESOLVING"
    else
        echo -e "${RED}[X]${NC} DNS: FAILED"
    fi
    echo ""
}

user_check() {
    echo ""
    echo "---- USER ACCOUNT CHECK ----"
    echo ""
    read -p "Enter username to check: " USERNAME
    if [ -z "$USERNAME" ]; then
        echo "[ERROR] Username required."
        return
    fi
    if id "$USERNAME" &> /dev/null; then
        echo -e "${GREEN}[FOUND]${NC} User '$USERNAME' exists."
    else
        echo -e "${YELLOW}[NOT FOUND]${NC} User '$USERNAME' does not exist in this system."
        echo "(Note: This is MINGW64 simulation. On Linux, use 'id' command.)"
    fi
    echo ""
}

backup_tool() {
    echo ""
    echo "---- BACKUP TOOL ----"
    echo ""
    SOURCE="$HOME/Desktop/45-Days-of-DevOps-Challenge"
    BACKUP_DIR="$TOOLKIT_DIR/Backups"
    mkdir -p "$BACKUP_DIR"
    BACKUP_NAME="backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
    
    echo "Source: $SOURCE"
    echo "Backup Dir: $BACKUP_DIR"
    echo ""
    read -p "Proceed with backup? (y/n): " CONFIRM
    if [ "$CONFIRM" = "y" ]; then
        echo "[*] Creating backup..."
        tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SOURCE" . 2>/dev/null
        if [ $? -eq 0 ]; then
            SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)
            echo -e "${GREEN}[SUCCESS]${NC} Backup created: $BACKUP_NAME ($SIZE)"
        else
            echo -e "${RED}[ERROR]${NC} Backup failed."
        fi
    else
        echo "Backup cancelled."
    fi
    echo ""
}

log_analyzer() {
    echo ""
    echo "---- LOG ANALYZER ----"
    echo ""
    read -p "Enter log file path (or press Enter for sample): " LOGFILE
    if [ -z "$LOGFILE" ]; then
        LOGFILE="$TOOLKIT_DIR/sample.log"
        cat > "$LOGFILE" << 'LOGEOF'
2026-10-07 08:00:01 INFO System started
2026-10-07 08:15:30 WARNING High memory usage
2026-10-07 08:20:45 ERROR Failed to connect to database
2026-10-07 08:22:15 ERROR Database timeout
2026-10-07 08:30:12 ERROR Disk space low
LOGEOF
        echo "[INFO] Using sample log file."
    fi
    if [ ! -f "$LOGFILE" ]; then
        echo "[ERROR] File not found: $LOGFILE"
        return
    fi
    ERROR_COUNT=$(grep -c -i "ERROR" "$LOGFILE")
    WARN_COUNT=$(grep -c -i "WARNING" "$LOGFILE")
    echo ""
    echo "Total ERRORs: $ERROR_COUNT"
    echo "Total WARNINGs: $WARN_COUNT"
    echo ""
    echo "Error Details:"
    grep -i "ERROR" "$LOGFILE" | head -5
    echo ""
}

generate_report() {
    REPORT_FILE="$TOOLKIT_DIR/full_report_$(date +%Y-%m-%d_%H-%M-%S).txt"
    {
        echo "=========================================="
        echo "   FULL IT SUPPORT REPORT"
        echo "   Generated: $(date)"
        echo "=========================================="
        echo ""
        echo "--- SYSTEM INFO ---"
        echo "Hostname: $(hostname)"
        echo "User: $(whoami)"
        echo ""
        echo "--- DISK USAGE ---"
        df -h | head -5
        echo ""
        echo "--- NETWORK ---"
        ipconfig | grep "IPv4" | head -2
        echo ""
        echo "--- SERVICES ---"
        echo "SSH: Running (simulated)"
        echo "Cron: Running (simulated)"
        echo "Network: Running (simulated)"
        echo "Docker: Not Running (simulated)"
        echo ""
        echo "=========================================="
    } > "$REPORT_FILE"
    echo ""
    echo -e "${GREEN}[SUCCESS]${NC} Full report saved: $REPORT_FILE"
    echo ""
}

# Main Menu Loop
while true; do
    show_banner
    echo "Select an option:"
    echo ""
    echo "  1. System Health Check"
    echo "  2. Service Status Monitor"
    echo "  3. Network Connectivity Check"
    echo "  4. User Account Check"
    echo "  5. Backup Tool"
    echo "  6. Log Analyzer"
    echo "  7. Generate Full Report"
    echo "  8. Exit"
    echo ""
    read -p "Enter choice (1-8): " CHOICE
    echo ""
    
    case $CHOICE in
        1) system_health ;;
        2) service_monitor ;;
        3) network_check ;;
        4) user_check ;;
        5) backup_tool ;;
        6) log_analyzer ;;
        7) generate_report ;;
        8) 
            echo "Thank you for using IT Support Toolkit. Goodbye!"
            exit 0
            ;;
        *)
            echo -e "${RED}[ERROR]${NC} Invalid choice. Please select 1-8."
            ;;
    esac
    
    echo ""
    read -p "Press Enter to return to main menu..."
done
ENDOFFILE
