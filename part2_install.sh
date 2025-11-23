#!/bin/bash

# =======================================================
# SCRIPT 2/2: Firewall, Dipendenze e Installazione LGSM
# Esegue: UFW, Dipendenze, Creazione Utente, Installazione
# =======================================================

echo "--- PARTE 2: Avvio Installazione Server Eco ---"

# Controlla se l'utente è root o può usare sudo
if [[ $EUID -ne 0 ]]; then
   echo "Questo script deve essere eseguito con privilegi sudo."
   exec sudo "$0" "$@"
fi

# 1. Installazione di CURL e UFW
echo "Installazione di curl e ufw..."
sudo apt install curl ufw -y

# 2. Configurazione Firewall (UFW)
echo "Configurazione Firewall (UFW)..."

# Rimuovi eventuali regole che potresti aver tentato di aggiungere
sudo ufw delete allow 3000/udp 2>/dev/null
sudo ufw delete allow 3001/tcp 2>/dev/null

# Regole di base per SSH e le porte Eco (3000-3002)
sudo ufw allow ssh comment 'Permetti SSH'
sudo ufw allow 3000:3002/tcp comment 'Eco Server Ports (TCP)'
sudo ufw allow 3000:3002/udp comment 'Eco Server Ports (UDP)'
echo "Abilitazione Firewall. Rispondi 'y' se richiesto."
sudo ufw enable

# 3. Installazione Dipendenze per SteamCMD e LGSM
echo "Installazione dipendenze 32-bit e pacchetti necessari..."
sudo dpkg --add-architecture i386
sudo apt update -y
sudo apt install bc binutils bsdmainutils distro-info jq lib32gcc-s1 lib32stdc++6 libgdiplus libsdl2-2.0-0:i386 netcat-openbsd pigz tmux unzip uuid-runtime wget xz-utils -y

# 4. Creazione Utente Non-Root per il Server
# L'installazione di LinuxGSM richiede un utente dedicato
if id "ecoserver" &>/dev/null; then
    echo "L'utente 'ecoserver' esiste già."
else
    echo "Creazione dell'utente 'ecoserver'..."
    sudo adduser ecoserver --disabled-password --gecos ""
    # Aggiungi l'utente al gruppo 'sudo' temporaneamente per l'installazione se necessario (opzionale)
    # sudo usermod -aG sudo ecoserver
fi

# 5. Installazione LinuxGSM (ecoserver)
echo "--- Avvio Installazione LinuxGSM per il server Eco (ecoserver) ---"
echo "Questo processo scaricherà e configurerà il gestore."

# Esegui come utente 'ecoserver'
su - ecoserver -c '
    echo "Ora come utente ecoserver..."
    curl -Lo ./ecoserver https://linuxgsm.sh && chmod +x ./ecoserver
    ./ecoserver auto-install

    echo "--------------------------------------------------------"
    echo "L\'installazione di Eco Server è stata avviata."
    echo "Dopo il completamento, puoi gestire il server con i seguenti comandi dopo aver eseguito 'su - ecoserver':"
    echo "./ecoserver start"
    echo "./ecoserver status"
    echo "--------------------------------------------------------"
'

echo "--- Fine dello script ---"
