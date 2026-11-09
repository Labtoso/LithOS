#!/bin/bash
set -e
pacman -Sy --noconfirm --needed base-devel git >/dev/null
useradd -m b 2>/dev/null || true
cp -r /src /home/b/w && chown -R b /home/b/w
cd /home/b/w
deps=$(bash -c 'source PKGBUILD; echo ${depends[@]} ${makedepends[@]}')
pacman -S --noconfirm --needed $deps >/dev/null
sudo -u b env MAKEFLAGS=-j4 makepkg -f --noconfirm --skippgpcheck
cp *.pkg.tar.zst /out/
