#!/bin/bash

# Linux User Account Management Script
# Day 9 of 45-Day DevOps Challenge

echo "=========================================="
echo "   USER ACCOUNT MANAGEMENT TOOL"
echo "   Generated: $(date)"
echo "=========================================="
echo ""

echo "Select an option:"
echo "1. Create a new user account"
echo "2. List all user accounts"
echo "3. Reset a user's password"
echo "4. Delete a user account"
echo "5. Check if a user exists"
echo "6. Exit"
echo ""
read -p "Enter your choice (1-6): " CHOICE

case $CHOICE in
    1)
        read -p "Enter new username: " USERNAME
        if id "$USERNAME" &>/dev/null; then
            echo "[ERROR] User '$USERNAME' already exists."
        else
            echo "[INFO] Creating user '$USERNAME'..."
            echo "[SIMULATION] In real Linux: sudo useradd -m $USERNAME"
            echo "[SUCCESS] User '$USERNAME' created (simulated)."
        fi
        ;;
    2)
        echo "[INFO] Listing all user accounts..."
        cut -d: -f1 /etc/passwd | head -20
        ;;
    3)
        read -p "Enter username: " USERNAME
        if id "$USERNAME" &>/dev/null; then
            echo "[INFO] Resetting password for '$USERNAME'..."
            echo "[SIMULATION] In real Linux: sudo passwd $USERNAME"
            echo "[SUCCESS] Password reset (simulated)."
        else
            echo "[ERROR] User '$USERNAME' does not exist."
        fi
        ;;
    4)
        read -p "Enter username: " USERNAME
        if id "$USERNAME" &>/dev/null; then
            echo "[INFO] Deleting user '$USERNAME'..."
            echo "[SIMULATION] In real Linux: sudo userdel -r $USERNAME"
            echo "[SUCCESS] User deleted (simulated)."
        else
            echo "[ERROR] User '$USERNAME' does not exist."
        fi
        ;;
    5)
        read -p "Enter username: " USERNAME
        if id "$USERNAME" &>/dev/null; then
            echo "[FOUND] User '$USERNAME' exists."
            id "$USERNAME"
        else
            echo "[NOT FOUND] User '$USERNAME' does not exist."
        fi
        ;;
    6)
        echo "Exiting. Goodbye!"
        exit 0
        ;;
    *)
        echo "[ERROR] Invalid choice. Please select 1-6."
        ;;
esac

echo ""
echo "=========================================="
echo "   END OF TOOL"
echo "=========================================="
