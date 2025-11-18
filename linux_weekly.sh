#!/bin/bash

# Detect package manager
if command -v apt >/dev/null 2>&1; then
    PM="apt"
elif command -v dnf >/dev/null 2>&1; then
    PM="dnf"
elif command -v yum >/dev/null 2>&1; then
    PM="yum"
elif command -v zypper >/dev/null 2>&1; then
    PM="zypper"
elif command -v pacman >/dev/null 2>&1; then
    PM="pacman"
else
    echo "No supported package manager found."
    exit 1
fi

echo "Detected package manager: $PM"

# Run maintenance commands based on package manager
case "$PM" in
    apt)
        echo "Running autoremove..."
        sudo apt autoremove -y
        echo "Cleaning cache..."
        sudo apt clean all
        echo "Updating package lists..."
        sudo apt update -y
        echo "Upgrading packages..."
        sudo apt upgrade -y
        ;;
    dnf)
        echo "Running autoremove..."
        sudo dnf autoremove -y
        echo "Cleaning cache..."
        sudo dnf clean all
        echo "Updating package lists..."
        sudo dnf check-update -y
        echo "Upgrading packages..."
        sudo dnf upgrade -y
        ;;
    yum)
        echo "Running autoremove..."
        sudo yum autoremove -y
        echo "Cleaning cache..."
        sudo yum clean all
        echo "Updating package lists..."
        sudo yum check-update -y
        echo "Upgrading packages..."
        sudo yum upgrade -y
        ;;
esac

echo "System maintenance completed successfully!"

