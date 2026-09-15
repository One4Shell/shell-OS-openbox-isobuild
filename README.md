# arch-dev-live

ISO Arch Linux personalizzata basata su **archiso**, con ambiente grafico minimale **Openbox** e stack di sviluppo pronto all'uso: **VS Code**, **Podman**, **Node.js** e **PHP**.

## Contenuto

- Ambiente grafico: Xorg + Openbox + LightDM
- Rete: NetworkManager (abilitato al boot)
- Container: Podman + podman-compose (abilitato al boot)
- Sviluppo: Node.js, npm, PHP, VS Code (`code`)

## Requisiti

- Un sistema Linux (o container Docker/Podman con immagine `archlinux`) per la build locale
- `archiso` installato (`pacman -S archiso`)

## Clonare il repository

```bash
git clone https://github.com/<tuo-utente>/arch-dev-live.git
cd arch-dev-live
```

Nota: la cartella `profile/` in questo repository contiene solo i file personalizzati.
Prima della prima build, copia i file di base del profilo `releng` di archiso
(pacman.conf, syslinux, grub, ecc.) se non presenti:

```bash
cp -rn /usr/share/archiso/configs/releng/* profile/
```

## Modificare i pacchetti

L'elenco dei pacchetti installati nella ISO si trova in:

```
profile/packages.x86_64
```

Aggiungi o rimuovi una riga per pacchetto (un pacchetto per riga, i commenti iniziano con `#`).

## Build locale (opzionale)

```bash
sudo mkarchiso -v -w work/ -o out/ profile/
```

L'ISO risultante sarà disponibile nella cartella `out/`.

## Build automatica su GitHub Actions

Ogni push su `main` che modifica la cartella `profile/` o il workflow stesso avvia automaticamente la build. Puoi anche avviarla manualmente:

1. Vai su **Actions** nel repository GitHub.
2. Seleziona il workflow **Build Arch Dev Live ISO**.
3. Clicca su **Run workflow**.

Al termine della build, l'ISO sarà scaricabile come **artifact** (`arch-dev-live-iso`) dalla pagina di riepilogo dell'esecuzione, sotto la sezione "Artifacts".

## Note

- Utente di default nella live session: `liveuser` (come da profilo `releng` di archiso).
- Per abilitare l'autologin grafico, modifica lo script `profile/airootfs/root/customize_airootfs.sh` decommentando le righe relative a LightDM.
- Podman è configurato in modalità rootless/rootful di default in base alla configurazione standard del pacchetto Arch; verifica `/etc/containers/` per personalizzazioni.
