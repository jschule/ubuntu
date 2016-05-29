#!/bin/bash
set -e
git add -A Packages Packages.bz2 InRelease Release Release.gpg deb
git commit -m "automatic"
git push

