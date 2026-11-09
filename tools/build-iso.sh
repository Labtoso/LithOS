#!/bin/bash
set -e
cd /tmp
curl -sSLO https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-keyring-20240331-1-any.pkg.tar.zst
pacman -U --noconfirm cachyos-keyring-20240331-1-any.pkg.tar.zst
pacman-key --init >/dev/null 2>&1 || true
pacman-key --populate archlinux cachyos
if ls /repo/*.pkg.tar.zst >/dev/null 2>&1; then repo-add -q /repo/lithos.db.tar.gz /repo/*.pkg.tar.zst; fi
mkarchiso -v -r -w /tmp/work -o /out /profile
