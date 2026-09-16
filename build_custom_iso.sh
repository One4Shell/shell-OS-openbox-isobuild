#!/usr/bin/env bash
# Build della ISO arch-dev-live.
# La work dir viene SEMPRE rimossa prima della build: mkarchiso non la pulisce
# da sola e un airootfs parzialmente popolato (es. liveuser gia' creato)
# fa fallire customize_airootfs.sh con "useradd: user 'liveuser' already exists".
set -euo pipefail

# Dipendenze host richieste da mkarchiso (grub serve per il boot mode 'uefi.grub')
for _cmd in mkarchiso grub-mkstandalone grub-install; do
  if ! command -v "$_cmd" >/dev/null 2>&1; then
    echo "ERRORE: '$_cmd' non trovato. Installa le dipendenze host con:" >&2
    echo "  sudo pacman -S --needed archiso grub" >&2
    exit 1
  fi
done

sudo rm -rf ./out ./work

cd "$(dirname "$0")"

# Copia i file base del profilo releng mancanti (non sovrascrive i nostri)
cp -rn /usr/share/archiso/configs/releng/* profile/

sudo rm -rf work out
sudo mkarchiso -v -w work/ -o out/ profile/

echo "ISO pronta in: $(pwd)/out/"
