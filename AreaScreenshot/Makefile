
area_screenshot : area_screenshot.vala
	valac --pkg gio-2.0 --pkg gtk+-3.0 ./area_screenshot.vala -o ./area_screenshot

install : area_screenshot
	mkdir -p ~/.local/share/utils/area_screenshot
	mkdir -p ~/.local/share/utils/bin
	mkdir -p ~/.local/share/dbus-1/services
	cp ./area_screenshot ~/.local/share/utils/bin/area_screenshot
	cp ./scripts/* ~/.local/share/utils/area_screenshot/
	mkdir -p ./temp_services
	rm -f ./temp_services/*
	cp ./services/* ./temp_services/
	find ./temp_services -type f | xargs sed -i -e "s,~,$(HOME),g"
	cp ./temp_services/* ~/.local/share/dbus-1/services/
	rm -r ./temp_services
