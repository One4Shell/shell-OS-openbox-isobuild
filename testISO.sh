qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp cores=2,threads=1,sockets=1 \
  -m 4090 \
  -display sdl,gl=on \
  -cdrom out/shellos-*.iso \
  -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22
