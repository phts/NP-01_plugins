#!/bin/bash

echo "Unistalling and cleaning up go-librespot files"

systemctl stop go-librespot-daemon.service
rm /lib/systemd/system/go-librespot-daemon.service
rm -f /tmp/go-librespot-config.yml
rm -f /bin/start-go-liberspot.sh

systemctl stop go-librespot-connect-daemon.service
rm /lib/systemd/system/go-librespot-connect-daemon.service
rm -f /tmp/go-librespot-connect-config.yml
rm -f /bin/start-go-librespot-connect.sh

rm /usr/bin/go-librespot
systemctl daemon-reload

rm /data/configuration/music_service/spop/spotifycredentials.json

echo "Done"
echo "pluginuninstallend"
