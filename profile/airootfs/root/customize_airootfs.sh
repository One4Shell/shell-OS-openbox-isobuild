#!/usr/bin/env bash
set -e -u

# 1. Crea l'utente 'liveuser' (idempotente: la work dir puo' essere riusata)
if ! id liveuser >/dev/null 2>&1; then
  useradd -m -g users -G wheel,storage,power,network,video,audio -s /bin/bash liveuser
fi

# 2. Rimuovi la password per l'utente liveuser (password vuota)
passwd -d liveuser

# 3. Abilita l'autologin senza password PAM per LightDM
getent group autologin >/dev/null || groupadd -r autologin
gpasswd -a liveuser autologin

usermod -aG wheel liveuser

# Abilita servizi di rete e container all'avvio
systemctl enable NetworkManager.service
#systemctl enable podman.socket
systemctl enable lightdm.service

# Layout tastiera italiano (setxkbmap NON funziona in chroot: nessun DISPLAY).
# Scriviamo i file di configurazione usati da Xorg e dalla console.
echo 'KEYMAP=it' > /etc/vconsole.conf
mkdir -p /etc/X11/xorg.conf.d
cat > /etc/X11/xorg.conf.d/00-keyboard.conf <<'EOF'
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "it"
        Option "XkbModel" "pc105"
EndSection
EOF

# LightDM: avvio diretto in modalità grafica (nessun autologin per default,
# rimuovi il commento sotto se vuoi autologin sull'utente live)
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-session=.*/autologin-session=openbox/' /etc/lightdm/lightdm.conf

exit 0
