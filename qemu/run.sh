#!/bin/bash
# arg is Ubuntu code name, e.g. wily, xenial ...
# defaults to last Ubuntu release

set -x

ubuntu=${1:-wily} ; shift

qemu-img create $ubuntu.raw 10G
exec qemu-system-x86_64 -name JTS-$ubuntu -vga std -drive file=$ubuntu.raw,if=virtio,cache=unsafe -m 1024 -kernel ipxe.lkrn -append "dhcp && chain http://jschule.github.io/ubuntu/qemu/$ubuntu.txt" "$@"
