Testing in a QEMU Virtual Machine
=================================

First, prepare a disk image with `qemu-img create ubuntu.raw 5G`

Ubuntu 15.10 Wily
------------------

```
qemu-system-x86_64 -vga std -hda ubuntu.raw -m 1024 -kernel ipxe.lkrn -append "dhcp && chain http://jschule.github.io/ubuntu/qemu/wily.txt"
```

Ubuntu 16.03 Xenial
--------------------

```
qemu-system-x86_64 -vga std -hda ubuntu.raw -m 1024 -kernel ipxe.lkrn -append "dhcp && chain http://jschule.github.io/ubuntu/qemu/xenial.txt"
```

Notes
-------

`ipxe.lkrn` copied from http://boot.ipxe.org/ipxe.lkrn. See http://ipxe.org for more infos about this great project.
