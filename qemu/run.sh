#!/bin/bash
# arg is Ubuntu code name, e.g. wily, xenial ...
# defaults to last Ubuntu release

set -x

ubuntu=${1:-wily}
qemu-img create $ubuntu.raw 5G
exec qemu-system-x86_64 -name JTS-$ubuntu -vga std -hda $ubuntu.raw -m 1024 -kernel ipxe.lkrn -append "dhcp && chain http://jschule.github.io/ubuntu/qemu/$ubuntu.txt" "$@"
