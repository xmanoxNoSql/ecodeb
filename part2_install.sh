#!/bin/bash

# =======================================================
# SCRIPT 2/2: Firewall, Dipendenze e Installazione LGSM
# =======================================================
# --------------------------
# 1. Installazione base
# --------------------------
apt update -y
apt install curl ufw -y

# --------------------------
# 2. Configurazione Firewall
# --------------------------
echo "Configurazione Firewall (UFW)..."

# Regole necessarie
ufw allow ssh comment 'Permetti SSH'
ufw allow 3000:3002/tcp comment 'Eco Server TCP Ports'
ufw allow 3000:3002/udp comment 'Eco Server UDP Ports'

echo "Abilitazione Firewall (rispondi 'y' se richiesto)..."
ufw enable

# --------------------------
# 3. Dipendenze LGSM / SteamCMD
# --------------------------
echo "Installazione dipendenze per LinuxGSM e SteamCMD..."

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
