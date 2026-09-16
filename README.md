# shell-os-live

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
git clone https://github.com/<tuo-utente>/shell-os-live.git
cd shell-os-live
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
./build_custom_iso.sh
```

Oppure manualmente, **pulendo sempre la work dir prima**:

```bash
sudo rm -rf work out
sudo mkarchiso -v -w work/ -o out/ profile/
```

L'ISO risultante sarà disponibile nella cartella `out/`.

> ⚠️ Non rilanciare `mkarchiso` su una `work/` già esistente: mkarchiso non
> ripulisce l'airootfs, quindi i file creati da `customize_airootfs.sh`
> (utente `liveuser`, gruppo `autologin`, servizi abilitati) restano e lo script
> fallisce con `useradd: user 'liveuser' already exists`.

## Build automatica su GitHub Actions

Il workflow **Build ShellOS ISO** (`.github/workflows/build-iso.yml`) esegue la build in un container `archlinux` privilegiato e viene avviato:

- ad ogni push su `main` che modifica la cartella `profile/`, lo script `build_custom_iso.sh` o il workflow stesso;
- una volta al mese (cron `0 3 1 * *`, il 1° del mese alle 03:00 UTC);
- manualmente da **Actions → Build ShellOS ISO → Run workflow**.

Al termine della build, l'ISO è scaricabile come **artifact** (`shellos-iso`, conservato 90 giorni) dalla pagina di riepilogo dell'esecuzione, sotto la sezione "Artifacts".

Ad ogni build viene inoltre aggiornata una **GitHub Release rolling** con tag fisso `shellos-latest`, che contiene sempre e solo l'ISO più recente. Poiché la ISO supera i 2 GiB (limite massimo per un asset di GitHub Releases), viene pubblicata **spezzata in parti** `shellos-latest-x86_64.iso.part-*`, insieme a `sha256sums.txt` e allo script `join-iso.sh`.

Per ricomporre la ISO, scarica tutti i file della release ([tag `shellos-latest`](https://github.com/One4Shell/shell-OS-openbox-isobuild/releases/tag/shellos-latest)) in una stessa cartella e poi:

```bash
bash join-iso.sh
# equivale a:
# cat shellos-latest-x86_64.iso.part-* > shellos-latest-x86_64.iso
# sha256sum -c sha256sums.txt
```

Su Windows (cmd):

```cmd
copy /b shellos-latest-x86_64.iso.part-00+shellos-latest-x86_64.iso.part-01 shellos-latest-x86_64.iso
```

## Note

- Utente di default nella live session: `liveuser` (come da profilo `releng` di archiso).
- Per abilitare l'autologin grafico, modifica lo script `profile/airootfs/root/customize_airootfs.sh` decommentando le righe relative a LightDM.
- Podman è configurato in modalità rootless/rootful di default in base alla configurazione standard del pacchetto Arch; verifica `/etc/containers/` per personalizzazioni.
