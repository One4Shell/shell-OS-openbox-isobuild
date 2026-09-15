#!/usr/bin/env bash
# Build della ISO arch-dev-live.
# La work dir viene SEMPRE rimossa prima della build: mkarchiso non la pulisce
# da sola e un airootfs parzialmente popolato (es. liveuser gia' creato)
# fa fallire customize_airootfs.sh con "useradd: user 'liveuser' already exists".
set -euo pipefail

cd "$(dirname "$0")"

# Copia i file base del profilo releng mancanti (non sovrascrive i nostri)
cp -rn /usr/share/archiso/configs/releng/* profile/

sudo rm -rf work out
sudo mkarchiso -v -w work/ -o out/ profile/

echo "ISO pronta in: $(pwd)/out/"
