# LithOS

Arch-basiertes Linux mit KDE Plasma, eigenem gehärteten Kernel und eigener Oberfläche.

## Inhalt

- `archiso/` – Profil der Live-ISO: Pakete, Bootmenü DE/EN, Live-Einrichtung, Installer-Konfiguration (Calamares), Design (Plymouth, GRUB, Look-and-Feel, SDDM, Sperrbildschirm), Update-Melder, Treiber-Einrichtung, Härtung
- `packages/linux-lithos/` – Kernel: CachyOS-Patchset mit BORE-Scheduler und Härtungs-Patches, zusätzliche Schutzoptionen, für alle x86-64-CPUs
- `packages/lithos-calamares/` – Installer (Calamares 3.4)
- `packages/lithos-apps/` – Paket für Willkommen und LithOS-Einstellungen
- `apps/lithos-center/` – Willkommen- und Einstellungs-App (Rust + Qt 6 / QML)
- `tools/` – Bauskripte

## Paketquelle

Installierte Systeme beziehen Kernel und LithOS-Apps aus der Paketquelle `[lithos]`
(GitHub-Release `repo`), alles andere aus Arch Linux und CachyOS.

## Bauen

Pakete (Kernel, Apps, Installer) im Container bauen, nach `repo/` legen, dann:

    docker run --rm --privileged -v $PWD/archiso:/profile:ro -v $PWD/out:/out -v $PWD/repo:/repo -v $PWD/tools/build-iso.sh:/build.sh:ro lithos-builder /build.sh
