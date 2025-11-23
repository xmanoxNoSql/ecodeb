#!/bin/bash

# =======================================================
# SCRIPT 2/2: Firewall, Dipendenze e Installazione LGSM
# =======================================================

echo "--- PARTE 2: Avvio Installazione Server Eco ---"

# Controlla privilegi root
if [[ $EUID -ne 0 ]]; then
   echo "Questo script deve essere eseguito come root. Rilancio con sudo..."
   exec sudo "$0" "$@"
fi

# --------------------------
# 1. Installazione base
# --------------------------
echo "Installazione pacchetti base: curl e ufw..."
apt update -y
apt install curl ufw -y

# --------------------------
# 2. Configurazione Firewall
# --------------------------
echo "Configurazione Firewall (UFW)..."

# Rimuovi vecchie regole, se presenti
ufw delete allow 3000:3002/tcp 2>/dev/null
ufw delete allow 3000:3002/udp 2>/dev/null

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
echo "Controllo utente 'ecoserver'..."

if id "ecoserver" &>/dev/null; then
    echo "L'utente 'ecoserver' esiste già."
else
    echo "L'utente non esiste. Creazione..."
    adduser ecoserver --disabled-password --gecos ""
fi

# --------------------------
# 5. Installazione LinuxGSM come 'ecoserver'
# --------------------------
echo "--- Avvio Installazione LinuxGSM (utente ecoserver) ---"

su - ecoserver << 'EOF'
echo "Ora come utente ecoserver!"
echo "Scarico e installo LinuxGSM..."

curl -Lo ~/ecoserver https://linuxgsm.sh
chmod +x ~/ecoserver

# Auto-install
~/ecoserver auto-install

echo "--------------------------------------------------------"
echo "Installazione completata."
echo "Comandi utili:"
echo "  ./ecoserver start"
echo "  ./ecoserver stop"
echo "  ./ecoserver restart"
echo "  ./ecoserver details"
echo "--------------------------------------------------------"
EOF

echo "--- Fine dello script 2/2 ---"
