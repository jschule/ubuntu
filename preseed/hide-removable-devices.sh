#!/bin/sh
set -x
cd /sys/block
for d in * ; do
    if test -r $d/removable && grep 1 $d/removable >/dev/null ; then
        rm -vf /dev/$d*
    fi
done
