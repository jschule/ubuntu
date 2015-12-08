DPKG=dpkg
DPKG_OPTS=-b
.PHONY: info repo deb

info: deb
	dpkg-deb -I out/*.deb
	dpkg-deb -c out/*.deb

deb: clean
	mkdir -p out
	test -d src && cp -r src build || mkdir -p build
	cp -r DEBIAN build
	V=$$(git rev-list --count HEAD -- .) ; sed -i -e "s/Version:.*/Version: $$V/" build/DEBIAN/control
	chmod -R g-w+rX,o+rX build
	test -x build.sh && { cd build ; set -x ; source ../build.sh ; } || :
	fakeroot ${DPKG} ${DPKG_OPTS} build out
	rm -Rf build
	lintian --suppress-tags changelog-file-missing-in-native-package,diversion-for-unknown-file,binary-without-manpage,no-copyright-file,file-in-etc-not-marked-as-conffile,unstripped-binary-or-object,statically-linked-binary,binary-from-other-architecture,arch-independent-package-contains-binary-or-object -i out/*.deb

repo: check_status deb
	../putinrepo.sh out/*.deb

clean:
	rm -fr out build

check_status:
	@git diff-index --quiet HEAD -- . || { echo ; git status -s -- . ; echo -e "\nERROR: All changes must be comitted!\n" ; false ; }
