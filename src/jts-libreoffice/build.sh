#!/bin/bash
set -e
VERSION=$(sed -n -e "/Version:/s/^.* //p" DEBIAN/control)
echo Using version $VERSION
sed -i -e "s/VERSION/$VERSION/g" usr/lib/libreoffice/share/extensions/jts-defaults/description.xml
