#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <log_file>"
  exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
  echo "Error: File '$LOG_FILE' not found."
  exit 1
fi

REPORT="log_report_$(date +%Y-%m-%d_%H-%M-%S).txt"

echo "===== Log Analysis Report =====" | tee "$REPORT"
echo "Log file: $LOG_FILE" | tee -a "$REPORT"
echo "Generated: $(date)" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

ERROR_COUNT=$(grep -c -i "ERROR" "$LOG_FILE")
FAILED_COUNT=$(grep -c -i "Failed" "$LOG_FILE")
CRITICAL_LINES=$(grep -n -i "CRITICAL" "$LOG_FILE")

echo "Total ERROR lines: $ERROR_COUNT" | tee -a "$REPORT"
echo "Total Failed lines: $FAILED_COUNT" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

echo "CRITICAL events:" | tee -a "$REPORT"
if [ -z "$CRITICAL_LINES" ]; then
  echo "  None found." | tee -a "$REPORT"
else
  echo "$CRITICAL_LINES" | tee -a "$REPORT"
fi

echo "" | tee -a "$REPORT"
echo "Report saved to: $REPORT" | tee -a "$REPORT"
