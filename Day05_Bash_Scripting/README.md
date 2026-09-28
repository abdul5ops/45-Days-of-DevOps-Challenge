#!/bin/bash

echo "====================================="
echo "   Welcome to Day 5 Health Check     "
echo "====================================="

read -p "Abdul Gaffar" USER_NAME
echo "Hello $USER_NAME, your system checking..."
echo "-------------------------------------"

# CPU Usage
CPU=$(wmic cpu get loadpercentage 2>/dev/null | grep -E "^[0-9]+" | awk '{print $1}')

if [ -z "$CPU" ]; then
    CPU="0"
fi

# Memory Usage
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
MEM_USED=$((MEM_TOTAL - MEM_AVAILABLE))
MEM_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($MEM_USED / $MEM_TOTAL) * 100}")

# Output dikhana
echo "CPU Usage   : $CPU%"
echo "Memory Usage: $MEM_PERCENT%"
echo "-------------------------------------"
echo 'System check complete. Have a great Day 5!'
