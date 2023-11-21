#!/bin/bash

echo "Unistalling go-librespot-daemon"

rm /usr/bin/go-librespot
rm /lib/systemd/system/go-librespot-daemon.service
rm -f /tmp/go-librespot-config.yml

echo "Done"
echo "pluginuninstallend"
