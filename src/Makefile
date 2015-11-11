DPKG=dpkg
DPKG_OPTS=-b
.PHONY: info repo deb

info: deb
	dpkg-deb -I out/*.deb
	dpkg-deb -c out/*.deb

deb:	clean check_status
	mkdir -p out
	test -d src && cp -r src build || mkdir -p build
	cp -r DEBIAN build
	V=$$(git rev-list HEAD | wc -l) ; sed -i -e "s/Version:.*/Version: $$V/" build/DEBIAN/control
	chmod -R g-w,o+rX build
	fakeroot ${DPKG} ${DPKG_OPTS} build out
	rm -Rf build
	lintian --suppress-tags changelog-file-missing-in-native-package,diversion-for-unknown-file,binary-without-manpage,no-copyright-file,file-in-etc-not-marked-as-conffile,unstripped-binary-or-object,statically-linked-binary -i out/*.deb

repo: deb
	../putinrepo.sh out/*.deb

clean:
	rm -fr out build

check_status:
	@git diff-index --quiet HEAD -- || { echo ; git status -s ; echo -e "\nERROR: All changes must be comitted!\n" ; false ; }
