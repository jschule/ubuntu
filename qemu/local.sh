#!/bin/bash
# arg is Ubuntu code name, e.g. wily, xenial ...
# defaults to last Ubuntu release

set -x

dist=${1:-eoan} ; shift

qemu-img create -f raw $dist.raw 10G
exec qemu-system-x86_64 \
    -enable-kvm \
    -name JTS-$dist \
    -m 1024 -cpu max -smp 4 \
    -vga virtio \
    -boot order=cn,menu=on \
    -drive file=$dist.raw,format=raw,if=virtio,cache=unsafe \
    -netdev user,id=n0,tftp=$(pwd),bootfile=$dist.txt \
    -device virtio-net,netdev=n0 \
    "$@"
