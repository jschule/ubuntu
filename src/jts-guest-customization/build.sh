#!/bin/bash
set -e -E -x
mkdir -p usr/share/backgrounds
# low res: soffice --headless --convert-to "png" ../jts-guestuser.odg --outdir usr/share/backgrounds
unoconv -v -d graphics -o usr/share/backgrounds/jts-guestuser.png -f png ../jts-guestuser.odg
test -r usr/share/backgrounds/jts-guestuser.png
chmod -R g-w+rX,o+rX usr
