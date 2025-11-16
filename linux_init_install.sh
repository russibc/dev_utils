#!/bin/bash

echo "Starting setup..."

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

# Helper function for removing packages
remove_pkg() {
    case "$PM" in
        apt)    sudo apt remove -y "$@" ;;
        dnf)    sudo dnf remove -y "$@" ;;
        yum)    sudo yum remove -y "$@" ;;
        zypper) sudo zypper remove -y "$@" ;;
        pacman) sudo pacman -Rns --noconfirm "$@" ;;
    esac
}

# Helper function for cleaning/updating/upgrading
update_system() {
    case "$PM" in
        apt)
            sudo apt autoremove -y
            sudo apt clean
            sudo apt update -y
            sudo apt upgrade -y
            ;;
        dnf)
            sudo dnf autoremove -y
            sudo dnf clean all
            sudo dnf update -y
            sudo dnf upgrade -y
            ;;
        yum)
            sudo yum autoremove -y
            sudo yum clean all
            sudo yum update -y
            sudo yum upgrade -y
            ;;
        zypper)
            sudo zypper remove --clean-deps -y
            sudo zypper clean --all
            sudo zypper refresh
            sudo zypper update -y
            ;;
        pacman)
            sudo pacman -Rns --noconfirm $(pacman -Qdtq) 2>/dev/null
            sudo pacman -Scc --noconfirm
            sudo pacman -Syu --noconfirm
            ;;
    esac
}

# Remove unwanted packages
echo "Removing unwanted packages..."
remove_pkg eog evince rhythmbox totem gnome-maps gnome-calendar gnome-contacts gnome-weather gnome-boxes gnome-photos

# Install RPM Fusion repository (Fedora only)
if [[ "$PM" == "dnf" || "$PM" == "yum" ]]; then
    echo "Installing RPM Fusion repository..."
    sudo $PM install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
    sudo $PM install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

    echo "Updating Fedora's core group..."
    sudo $PM group update core -y
fi

# Clean cache, update, and upgrade packages
echo "Cleaning cache, updating, and upgrading packages..."
update_system

echo "Setup completed."
echo "Rebooting in..."
for i in {3..1}
do
    echo "$i..."
done
reboot now

