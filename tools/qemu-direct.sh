#!/bin/bash
# Schneller Test: Kernel direkt starten, Konsole auf /tmp/serial.log. Usage: qemu-direct.sh "extra params"
cd /home/user/lithos; rm -f /tmp/serial.log
qemu-system-x86_64 -m 6G -smp 4 -cpu ${CPU:-max} -machine q35 \
  -kernel kx/lithos/boot/x86_64/vmlinuz-linux-cachyos -initrd kx/lithos/boot/x86_64/initramfs-linux-cachyos.img \
  -append "archisobasedir=lithos archisosearchuuid=2026-11-06-20-57-50-00 lithos.lang=de console=tty0 console=ttyS0,115200 $1" \
  -cdrom out/lithos-2026.11.06-x86_64.iso -vga virtio -display none \
  -monitor unix:/tmp/qmon.sock,server,nowait -chardev socket,id=s0,path=/tmp/ser.sock,server=on,wait=off,logfile=/tmp/serial.log -serial chardev:s0 -nic user,model=virtio-net-pci &
echo $! > /tmp/qemu.pid
