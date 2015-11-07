touch "$HOME"/.skip-guest-warning-dialog
if test -r /usr/share/applications/google-chrome.desktop ; then
	mkdir -p "$HOME"/.local/share/applications
	sed -e '/Exec/s/google[a-z-]\+/& --no-default-browser-check --no-first-run --password-store=basic/' -e '/^Name=/s/=/&Guest /' \
		< /usr/share/applications/google-chrome.desktop > "$HOME"/.local/share/applications/google-chrome.desktop
fi

mkdir -p "$HOME"/.config/autostart
for service in blueman.desktop deja-dup-monitor.desktop indicator-bluetooth.desktop indicator-power.desktop light-locker.desktop vino-server.desktop nm-applet.desktop ; do
	if test -e /etc/xdg/autostart/$service ; then
		sed -e '$a X-GNOME-Autostart-enabled=false' < /etc/xdg/autostart/$service > "$HOME"/.config/autostart/$service
	fi
done

