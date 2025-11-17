#!/bin/bash

echo "Starting packages install..."

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

# Helper function for installs
install_pkg() {
    case "$PM" in
        apt)    sudo apt install -y "$@" ;;
        dnf)    sudo dnf install -y "$@" ;;
        yum)    sudo yum install -y "$@" ;;
        zypper) sudo zypper install -y "$@" ;;
        pacman) sudo pacman -S --noconfirm "$@" ;;
    esac
}

# Development Tools group (only works on dnf/yum/zypper)
if [[ "$PM" == "dnf" || "$PM" == "yum" || "$PM" == "zypper" ]]; then
    echo "Installing Development Tools group..."
    sudo $PM groupinstall 'Development Tools' -y
fi

# GitKraken (RPM only)
if [[ "$PM" == "dnf" || "$PM" == "yum" ]]; then
    wget https://release.gitkraken.com/linux/gitkraken-amd64.rpm -P /tmp/
    sudo $PM install -y /tmp/gitkraken-amd64.rpm
fi

# VS Code repo (RPM-based only)
if [[ "$PM" == "dnf" || "$PM" == "yum" ]]; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo tee /etc/yum.repos.d/vscode.repo <<EOF
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
    install_pkg code
fi

# Common installs
install_pkg docker
install_pkg openjdk-17-jdk || install_pkg java-latest-openjdk.x86_64
install_pkg python3-pip
install_pkg nodejs npm

# Database management (RPM only for DBeaver)
if [[ "$PM" == "dnf" || "$PM" == "yum" ]]; then
    wget https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm -P /tmp/
    sudo $PM install -y /tmp/dbeaver*
fi

# Multimedia
install_pkg gthumb vlc inkscape gimp

# Chrome (RPM only)
if [[ "$PM" == "dnf" || "$PM" == "yum" ]]; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm -P /tmp/
    sudo $PM install -y /tmp/google-chrome-stable_current_x86_64.rpm
fi

# Remote control (RPM only)
if [[ "$PM" == "dnf" || "$PM" == "yum" ]]; then
    wget https://www.unifiedremote.com/download/linux-x64-rpm -P /tmp/
    sudo $PM install -y /tmp/urserver*
fi

# Utilities
install_pkg gedit gparted transmission flatpak

echo "Starting installations using Flatpak..."
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.slack.Slack -y
flatpak install flathub com.valvesoftware.Steam -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub io.github.flattool.Warehouse -y
flatpak install flathub org.zotero.Zotero -y
flatpak install flathub org.eclipse.Java -y
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Ultimate -y
flatpak install flathub com.getpostman.Postman -y

echo "Flatpak installations finished!"

# Terminal colors
mkdir -p "$HOME/src"
cd "$HOME/src"
git clone https://github.com/Gogh-Co/Gogh.git gogh

echo "Full configuration completed."

