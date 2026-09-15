#!/usr/bin/env bash
set -e -u

# 1. Crea l'utente 'liveuser'
useradd -m -g users -G wheel,storage,power,network,video,audio -s /bin/bash liveuser

# 2. Rimuovi la password per l'utente liveuser (password vuota)
passwd -d liveuser

# 3. Abilita l'autologin senza password PAM per LightDM
groupadd -r autologin
gpasswd -a liveuser autologin

# Abilita servizi di rete e container all'avvio
systemctl enable NetworkManager.service
#systemctl enable podman.socket
systemctl enable lightdm.service

# LightDM: avvio diretto in modalità grafica (nessun autologin per default,
# rimuovi il commento sotto se vuoi autologin sull'utente live)
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-session=.*/autologin-session=openbox/' /etc/lightdm/lightdm.conf

exit 0
