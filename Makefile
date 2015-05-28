
lock : lock.vala
	valac --pkg gio-2.0 --pkg gnome-keyring-1 ./lock.vala -o ./lock
