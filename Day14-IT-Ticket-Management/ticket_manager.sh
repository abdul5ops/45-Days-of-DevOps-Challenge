#!/bin/bash

# IT Support Ticket Management Script
# Day 14 of 45-Day DevOps Challenge
# Simulates ITSM ticketing workflow (ITIL-based)

TICKET_DIR="$HOME/Desktop/IT-Support-Toolkit-Logs/Tickets"
TICKET_FILE="$TICKET_DIR/tickets.csv"
mkdir -p "$TICKET_DIR"

# Create header if file doesn't exist
if [ ! -f "$TICKET_FILE" ]; then
    echo "TicketID,Date,User,Category,Priority,Status,Description,Resolution" > "$TICKET_FILE"
fi

generate_ticket_id() {
    LAST_ID=$(tail -n +2 "$TICKET_FILE" | cut -d',' -f1 | sort -t'-' -k2 -n | tail -1 | cut -d'-' -f2)
    if [ -z "$LAST_ID" ]; then
        echo "INC-001"
    else
        NEXT_ID=$(printf "%03d" $((LAST_ID + 1)))
        echo "INC-$NEXT_ID"
    fi
}

create_ticket() {
    echo ""
    echo "---- CREATE NEW TICKET ----"
    echo ""
    read -p "User name: " USER
    read -p "Category (Hardware/Software/Network/Account/Other): " CATEGORY
    echo "Priority: 1-High, 2-Medium, 3-Low"
    read -p "Priority (1-3): " PRIORITY_NUM
    case $PRIORITY_NUM in
        1) PRIORITY="High" ;;
        2) PRIORITY="Medium" ;;
        3) PRIORITY="Low" ;;
        *) PRIORITY="Medium" ;;
    esac
    read -p "Issue description: " DESC
    
    TICKET_ID=$(generate_ticket_id)
    DATE=$(date +%Y-%m-%d)
    
    echo "$TICKET_ID,$DATE,$USER,$CATEGORY,$PRIORITY,Open,\"$DESC\",\"\"" >> "$TICKET_FILE"
    
    echo ""
    echo "[SUCCESS] Ticket created: $TICKET_ID"
    echo "Priority: $PRIORITY"
    echo "Status: Open"
    echo ""
    read -p "Press Enter to continue..."
}

list_tickets() {
    echo ""
    echo "---- ALL TICKETS ----"
    echo ""
    if [ ! -s "$TICKET_FILE" ] || [ $(wc -l < "$TICKET_FILE") -le 1 ]; then
        echo "No tickets found."
    else
        printf "%-10s %-12s %-12s %-10s %-10s %-10s\n" "TicketID" "Date" "User" "Category" "Priority" "Status"
        echo "--------------------------------------------------------------------------------"
        tail -n +2 "$TICKET_FILE" | while IFS=',' read -r id date user cat pri status desc res; do
            printf "%-10s %-12s %-12s %-10s %-10s %-10s\n" "$id" "$date" "$user" "$cat" "$pri" "$status"
        done
    fi
    echo ""
    read -p "Press Enter to continue..."
}

update_status() {
    echo ""
    echo "---- UPDATE TICKET STATUS ----"
    echo ""
    read -p "Enter Ticket ID (e.g., INC-001): " TID
    
    if ! grep -q "^$TID," "$TICKET_FILE"; then
        echo "[ERROR] Ticket not found: $TID"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo "New status: 1-Open, 2-In Progress, 3-Resolved, 4-Closed"
    read -p "Select (1-4): " STAT
    case $STAT in
        1) NEW_STATUS="Open" ;;
        2) NEW_STATUS="In Progress" ;;
        3) NEW_STATUS="Resolved" ;;
        4) NEW_STATUS="Closed" ;;
        *) NEW_STATUS="In Progress" ;;
    esac
    
    read -p "Resolution notes (optional): " RESOLUTION
    
    TMP_FILE=$(mktemp)
    while IFS=',' read -r id date user cat pri status desc res; do
        if [ "$id" = "$TID" ]; then
            echo "$id,$date,$user,$cat,$pri,$NEW_STATUS,\"$desc\",\"$RESOLUTION\"" >> "$TMP_FILE"
        else
            echo "$id,$date,$user,$cat,$pri,$status,\"$desc\",\"$res\"" >> "$TMP_FILE"
        fi
    done < "$TICKET_FILE"
    mv "$TMP_FILE" "$TICKET_FILE"
    
    echo ""
    echo "[SUCCESS] Ticket $TID updated to: $NEW_STATUS"
    echo ""
    read -p "Press Enter to continue..."
}

ticket_summary() {
    echo ""
    echo "---- TICKET SUMMARY REPORT ----"
    echo ""
    TOTAL=$(($(wc -l < "$TICKET_FILE") - 1))
    OPEN=$(grep -c ",Open," "$TICKET_FILE" 2>/dev/null || echo 0)
    INPROG=$(grep -c ",In Progress," "$TICKET_FILE" 2>/dev/null || echo 0)
    RESOLVED=$(grep -c ",Resolved," "$TICKET_FILE" 2>/dev/null || echo 0)
    CLOSED=$(grep -c ",Closed," "$TICKET_FILE" 2>/dev/null || echo 0)
    HIGH=$(grep -c ",High," "$TICKET_FILE" 2>/dev/null || echo 0)
    
    echo "Total Tickets: $TOTAL"
    echo ""
    echo "By Status:"
    echo "  Open:        $OPEN"
    echo "  In Progress: $INPROG"
    echo "  Resolved:    $RESOLVED"
    echo "  Closed:      $CLOSED"
    echo ""
    echo "By Priority:"
    echo "  High:   $HIGH"
    echo ""
    read -p "Press Enter to continue..."
}

# Main Menu
while true; do
    clear
    echo "=========================================="
    echo "   IT SUPPORT TICKET MANAGER v1.0"
    echo "   $(date)"
    echo "=========================================="
    echo ""
    echo "  1. Create New Ticket"
    echo "  2. View All Tickets"
    echo "  3. Update Ticket Status"
    echo "  4. Ticket Summary Report"
    echo "  5. Exit"
    echo ""
    read -p "Select option (1-5): " CHOICE
    
    case $CHOICE in
        1) create_ticket ;;
        2) list_tickets ;;
        3) update_status ;;
        4) ticket_summary ;;
        5) echo "Goodbye!"; exit 0 ;;
        *) echo "[ERROR] Invalid choice." ;;
    esac
done
ENDOFFILE
