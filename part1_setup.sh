#!/bin/bash

# =======================================================
# SCRIPT 1/2: Configurazione Iniziale e Riavvio
# Esegue: Aggiornamenti iniziali e installazione di SUDO
# =======================================================
# 1. Aggiornamento e Upgrade Iniziale
echo "Esecuzione di apt update e upgrade..."
apt update -y
apt upgrade -y

# 2. Installazione di Sudo (se non presente)
echo "Installazione di 'sudo' (necessario per i comandi futuri)..."
apt install sudo -y

reboot

# 1. Installazione base
# --------------------------
apt update -y
apt install curl ufw -y

# --------------------------
# 2. Configurazione Firewall
# --------------------------
# Regole necessarie
ufw allow ssh
ufw allow 3000:3002/tcp
ufw allow 3000:3002/udp

ufw enable

# --------------------------
# 3. Dipendenze LGSM / SteamCMD
# --------------------------
dpkg --add-architecture i386
apt update -y

apt install -y \
    bc binutils bsdmainutils distro-info jq \
    lib32gcc-s1 lib32stdc++6 libgdiplus libsdl2-2.0-0:i386 \
    netcat-openbsd pigz tmux unzip uuid-runtime wget xz-utils

# --------------------------
# 4. Creazione Utente ecoserver
# --------------------------
adduser ecoserver

# --------------------------
# 5. Installazione LinuxGSM come 'ecoserver'
# --------------------------
su - ecoserver 

curl -Lo linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh ecoserver

./ecoserver install
