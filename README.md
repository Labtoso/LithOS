# LithOS

Arch-basiertes Linux mit KDE Plasma, CachyOS-Kernel und eigener Oberfläche.

- `archiso/` – archiso-Profil der Live-ISO (Pakete, Bootmenü DE/EN, Live-Einrichtung, Logo, Wallpaper)
- `tools/build.sh` – baut die ISO im Container `lithos-builder` (archlinux + archiso)
- `tools/qemu-test.sh`, `tools/qemu-direct.sh` – Test in QEMU (UEFI bzw. direkter Kernelstart mit serieller Konsole)
- `tools/make-logo.py` – erzeugt die Logo-PNGs

Build:

    docker run --rm --privileged -v $PWD/archiso:/profile:ro -v $PWD/out:/out -v $PWD/tools/build.sh:/build.sh:ro lithos-builder /build.sh
