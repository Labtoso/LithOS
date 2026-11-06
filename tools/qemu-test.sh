#!/bin/bash
# Usage: qemu-test.sh ISO  -> startet LithOS in QEMU (UEFI), Screenshots über den Monitor
ISO="$1"; D=/home/user/lithos/shots; mkdir -p $D
cp /usr/share/OVMF/OVMF_VARS_4M.fd /tmp/ovmf_vars.fd
qemu-system-x86_64 -m 6G -smp 4 -cpu max -machine q35 \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd \
  -drive if=pflash,format=raw,file=/tmp/ovmf_vars.fd \
  -cdrom "$ISO" -boot d -vga virtio -display none \
  -monitor unix:/tmp/qmon.sock,server,nowait -serial file:/tmp/serial.log \
  -nic user,model=virtio-net-pci &
echo $! > /tmp/qemu.pid
