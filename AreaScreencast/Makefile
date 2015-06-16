
area_screencast : area_screencast.vala
	valac --pkg gio-2.0 ./area_screencast.vala -o ./area_screencast

install : area_screencast
	mkdir -p ~/.local/share/utils/area_screencast
	mkdir -p ~/.local/share/utils/bin
	mkdir -p ~/.local/share/dbus-1/services
	cp ./area_screencast ~/.local/share/utils/bin/area_screencast
	cp ./scripts/* ~/.local/share/utils/area_screencast/
	mkdir -p ./temp_services
	rm -f ./temp_services/*
	cp ./services/* ./temp_services/
	find ./temp_services -type f | xargs sed -i -e "s,~,$(HOME),g"
	cp ./temp_services/* ~/.local/share/dbus-1/services/
	rm -r ./temp_services
