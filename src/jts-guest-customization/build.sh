set -e -E -x
mkdir -p usr/share/backgrounds
soffice --headless --convert-to "png" ../jts-guestuser.odg --outdir usr/share/backgrounds
test -r usr/share/backgrounds/jts-guestuser.png
chmod -R g-w+rX,o+rX usr
