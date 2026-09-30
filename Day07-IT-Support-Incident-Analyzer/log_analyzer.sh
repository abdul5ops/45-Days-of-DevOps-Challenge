#!/bin/bash

echo "=========================================="
echo "   IT SUPPORT INCIDENT ANALYZER v1.0      "
echo "=========================================="
echo ""

if [ $# -eq 0 ]; then
    echo "[ERROR] Usage: $0 <log_file>"
    exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
    echo "[ERROR] Log file '$LOG_FILE' not found."
    exit 1
fi

DATE_STAMP=$(date +%Y-%m-%d_%H-%M-%S)
REPORT_FILE="Incident_Report_${DATE_STAMP}.txt"

echo "==========================================" > "$REPORT_FILE"
echo " IT INCIDENT REPORT " >> "$REPORT_FILE"
echo "==========================================" >> "$REPORT_FILE"
echo "Generated on: $(date)" >> "$REPORT_FILE"
echo "Analyzed Log: $LOG_FILE" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[*] Analyzing system logs..."
ERROR_COUNT=$(grep -c -i "ERROR" "$LOG_FILE")
WARNING_COUNT=$(grep -c -i "WARNING" "$LOG_FILE")

echo "------------------------------------------" >> "$REPORT_FILE"
echo " SUMMARY OF EVENTS" >> "$REPORT_FILE"
echo "------------------------------------------" >> "$REPORT_FILE"
echo "Total ERROR events: $ERROR_COUNT" >> "$REPORT_FILE"
echo "Total WARNING events: $WARNING_COUNT" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "------------------------------------------" >> "$REPORT_FILE"
echo " DETAILED ERROR LOGS" >> "$REPORT_FILE"
echo "------------------------------------------" >> "$REPORT_FILE"
grep -i "ERROR" "$LOG_FILE" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "------------------------------------------" >> "$REPORT_FILE"
echo " IT SERVICE MANAGEMENT (ITSM) SECTION" >> "$REPORT_FILE"
echo "------------------------------------------" >> "$REPORT_FILE"
echo "INCIDENT DETAILS:" >> "$REPORT_FILE"
echo "-----------------" >> "$REPORT_FILE"
echo "Priority Level: [High/Medium/Low]" >> "$REPORT_FILE"
echo "Affected System: [e.g., Database, Network, Server]" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "TROUBLESHOOTING STEPS TAKEN:" >> "$REPORT_FILE"
echo "-----------------------------" >> "$REPORT_FILE"
echo "1. " >> "$REPORT_FILE"
echo "2. " >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "RESOLUTION:" >> "$REPORT_FILE"
echo "-----------" >> "$REPORT_FILE"
echo "[Document how the issue was fixed here]" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "STATUS: [Open / In Progress / Resolved / Closed]" >> "$REPORT_FILE"

echo "[SUCCESS] Analysis complete!"
echo "[INFO] Incident report generated: $REPORT_FILE"
echo "=========================================="
