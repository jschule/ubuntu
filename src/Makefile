DPKG=dpkg
DPKG_OPTS=-b
.PHONY: info repo deb

info: deb
	dpkg-deb -I out/*.deb
	dpkg-deb -c out/*.deb

deb:	clean version_increment
	mkdir -p out
	test -d src && cp -r src build || mkdir -p build
	cp -r DEBIAN build
	chmod -R g-w,o+rX build
	fakeroot ${DPKG} ${DPKG_OPTS} build out
	rm -Rf build
	lintian --suppress-tags changelog-file-missing-in-native-package,diversion-for-unknown-file,binary-without-manpage,no-copyright-file,file-in-etc-not-marked-as-conffile -i out/*.deb

repo: deb
	../putinrepo.sh out/*.deb

install: repo
	sudo /etc/cron.daily/gss-autoupdate

clean:
	rm -fr out build

version_increment:
	V=$$(sed -ne '/Version/s/.* //p' DEBIAN/control ) ; sed -i -e "/Version/s/$$V/$$((++V))/" DEBIAN/control
