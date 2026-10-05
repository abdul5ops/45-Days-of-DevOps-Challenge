#!/bin/bash

echo "=========================================="
echo "   NETWORK CONNECTIVITY CHECKER"
echo "   Generated: $(date)"
echo "=========================================="
echo ""

LOG_FILE="network_check_$(date +%Y-%m-%d_%H-%M-%S).log"

echo "Starting network diagnostics..." | tee "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

echo "---- TEST 1: Local IP Configuration ----" | tee -a "$LOG_FILE"
ipconfig | grep -A 5 "IPv4" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

echo "---- TEST 2: Ping Google DNS (8.8.8.8) ----" | tee -a "$LOG_FILE"
if ping -n 2 8.8.8.8 &> /dev/null || ping -c 2 8.8.8.8 &> /dev/null; then
    echo "[OK] Internet connectivity is WORKING." | tee -a "$LOG_FILE"
else
    echo "[FAIL] Internet connectivity is DOWN." | tee -a "$LOG_FILE"
fi
echo "" | tee -a "$LOG_FILE"

echo "---- TEST 3: DNS Resolution ----" | tee -a "$LOG_FILE"
if nslookup google.com &> /dev/null; then
    echo "[OK] DNS is resolving correctly." | tee -a "$LOG_FILE"
else
    echo "[FAIL] DNS resolution FAILED. Try: ipconfig /flushdns" | tee -a "$LOG_FILE"
fi
echo "" | tee -a "$LOG_FILE"

echo "---- TEST 4: HTTPS Connectivity ----" | tee -a "$LOG_FILE"
if curl -s -I https://www.google.com | head -1 | grep -q "HTTP"; then
    echo "[OK] HTTPS connectivity is WORKING." | tee -a "$LOG_FILE"
else
    echo "[FAIL] HTTPS connectivity is FAILING." | tee -a "$LOG_FILE"
fi
echo "" | tee -a "$LOG_FILE"

echo "==========================================" | tee -a "$LOG_FILE"
echo " DIAGNOSTIC SUMMARY" | tee -a "$LOG_FILE"
echo "==========================================" | tee -a "$LOG_FILE"
echo "If any test failed, try:" | tee -a "$LOG_FILE"
echo "  1. Check cable / Wi-Fi" | tee -a "$LOG_FILE"
echo "  2. ipconfig /release && ipconfig /renew" | tee -a "$LOG_FILE"
echo "  3. ipconfig /flushdns" | tee -a "$LOG_FILE"
echo "  4. Restart router" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "Report saved to: $LOG_FILE"
echo "=========================================="
