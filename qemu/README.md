Testing in a QEMU Virtual Machine
=================================

You need 5 GB free disk space for each Ubuntu version.

Run the `run.sh` script with the desired Ubuntu code name as argument. Examples:

* `run.sh wily` to start with Ubuntu 15.10
* `run.sh xenial` to start with Ubuntu 16.04

Notes
-------

`ipxe.lkrn` copied from http://boot.ipxe.org/ipxe.lkrn. See http://ipxe.org for more infos about this great project.

Use `qemu-img info <image.raw>` to see how much space an image actually uses.
