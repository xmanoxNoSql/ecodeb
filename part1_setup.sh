#!/bin/bash

# =======================================================
# SCRIPT 1/2: Configurazione Iniziale e Riavvio
# Esegue: Aggiornamenti iniziali e installazione di SUDO
# =======================================================

echo "--- PARTE 1: Avvio Setup Iniziale ---"

# 1. Aggiornamento e Upgrade Iniziale
echo "Esecuzione di apt update e upgrade..."
apt update -y
apt upgrade -y

# 2. Installazione di Sudo (se non presente)
echo "Installazione di 'sudo' (necessario per i comandi futuri)..."
apt install sudo -y

# 3. Riavvio (Necessario dopo l'upgrade del kernel/pacchetti)
echo "!!! ATTENZIONE: Il sistema si riavvierà in 10 secondi !!!"
echo "Dopo il riavvio, dovrai eseguire lo script 'part2_install.sh' come utente con privilegi sudo."
sleep 10
sudo reboot
