#!/bin/bash
#
# Trivial DEB repo management
#
# Written by Schlomo Schapiro
# Licensed under the GNU General Public License, see http://www.gnu.org/licenses/gpl.html for full text
set -e -E -u
if [[ ! "${REPO_BASE_DIR:-}" ]] ; then
    ME_DIR="$(dirname "$(readlink -f "$0")")"
    for CHECK_DIR in "$ME_DIR" "$ME_DIR"/.. "$ME_DIR"/../.. ; do
        if [[ -r "$CHECK_DIR"/config_for_release ]] ; then
            export REPO_BASE_DIR="$(readlink -f "$CHECK_DIR")"
            break
        fi
    done
    if [[ ! "${REPO_BASE_DIR:-}" ]] ; then
        echo "Could not guess your repo path ($ME_DIR $ME_DIR/.. $ME_DIR/../.. ), please set REPO_BASE_DIR"
	echo "The repo should contain a file named config_for_release with stuff like"
	echo ' APT::FTPArchive::Release::Architectures "amd64 armhf armel i386";'
	echo ' APT::FTPArchive::Release::Origin "Private";'
	echo "in it"
 
        exit 1
    fi
elif [[ ! -r "$REPO_BASE_DIR"/config_for_release ]] ; then
    echo "$REPO_BASE_DIR does not seem to be a repo"
    exit 1
else
    : # REPO_BASE_DIR is set and a dir and contains a conf/distributions, nothing to do
    
fi 
 
echo "* * * Repo in $REPO_BASE_DIR"
 
WORK_DIR="$(mktemp -d)"
trap "rm -Rf $WORK_DIR" 0
 
# if you sign the repo to make apt happy and not for real security then you can put the GPG stuff into 
# the key subdir and we will use it.
if [[ -d "$REPO_BASE_DIR"/key ]] ; then
    echo "Using '$REPO_BASE_DIR/key' for GnuPG"
    cp -r "$REPO_BASE_DIR"/key "$WORK_DIR"
    chmod g-rwx,o-rwx -R "$WORK_DIR"/key
    export GNUPGHOME="$WORK_DIR"/key
fi

if [[ "${1:-}" ]] ; then
    mkdir -p "$REPO_BASE_DIR"/deb
    for parm in "$@" ; do
        f="$(readlink -f "$parm")" # normalize file
        if [ ! -s "$f" ]; then
            echo "ERROR: Parameter '$parm' does not point to a readable file ($f)"
            exit 1
        fi
 
        eval $(dpkg-deb --show --showformat 'package_name="${Package}"\npackage_version="${Version}"\npackage_arch="${Architecture}"' "$f")
        canonical_name="${package_name}_${package_version}_${package_arch}.deb"
        echo -n "Adding '$f': "
        if [[ -r "$REPO_BASE_DIR"/deb/"$canonical_name" ]] ; then
            echo -e "ERROR\n\tNOT OVERWRITING EXISTING PACKAGE WITH SAME VERSION!"
        else
            cp "$f" "$REPO_BASE_DIR"/deb/"$canonical_name" && echo "OK"
            all_packages=( $(ls -rt "$REPO_BASE_DIR"/deb/"$package_name"* ) )
            if (( ${#all_packages[*]} > 1 )) ; then
                unset 'all_packages[-1]'
                if (( ${#all_packages[*]} > 0 )) ; then
                    echo "Removing old packages:"
                    rm -fv "${all_packages[@]}"
                fi
            fi
        fi
    done
fi
 
cd "$REPO_BASE_DIR"
apt-ftparchive packages . | tee Packages | bzip2 >Packages.bz2
apt-ftparchive -c config_for_release release . | grep -v " Release" >Release
gpg --verbose --output Release.gpg --batch --yes -ba Release

git add -A Packages Packages.bz2 Release Release.gpg deb
git commit -m "putinrepo"
git push
# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
