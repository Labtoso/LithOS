#!/bin/bash
set -e
pacman -Sy --noconfirm --needed base-devel rust clang qt6-base qt6-declarative kitty pacman-contrib libnotify >/dev/null
useradd -m b 2>/dev/null || true
mkdir -p /home/b/w && cp /pkg/PKGBUILD /home/b/w/
cp -r /app /home/b/w/lithos-center && rm -rf /home/b/w/lithos-center/target
chown -R b /home/b/w
cd /home/b/w/lithos-center
[ -f Cargo.lock ] || sudo -u b cargo generate-lockfile
cp Cargo.lock /appout/Cargo.lock
cd /home/b/w && sudo -u b tar czf lithos-center.tar.gz lithos-center
sudo -u b env CARGO_HOME=/home/b/.cargo makepkg -f --noconfirm 2>&1 | tail -40
cp lithos-apps-*.pkg.tar.zst /out/
