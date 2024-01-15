#!/bin/bash

ARCH=$(cat /etc/os-release | grep ^VOLUMIO_ARCH | tr -d 'VOLUMIO_ARCH="')

if [ $ARCH = "arm" ]; then
  ARCH="armv6_rpi"
elif [ $ARCH = "armv7" ]; then
  ARCH="armv6"
elif [ $ARCH = "amd64" ] || [ $ARCH = "x86_64" ] || [ $ARCH = "x64" ]; then
  ARCH="x86_64"
elif [ $ARCH = "i386" ] || [ $ARCH = "i686" ] || [ $ARCH = "x86" ]; then
  echo "Platform not supported"
  exit 1
fi

echo "Checking old vollibrespot installs"

killall vollibrespot
systemctl stop volspotconnect.service
systemctl disable volspotconnect.service
systemctl daemon-reload

## Spotify legacy
VOLLIB_PATH=/usr/bin/vollibrespot
VOLLIB_SYSTEMD=/lib/systemd/system/volspotconnect.service
if [ -f $VOLLIB_PATH ]; then
  echo "Clearing old vollibrespot"
  rm $VOLLIB_PATH
  [ -f $VOLLIB_SYSTEMD ] || rm $VOLLIB_SYSTEMD
  echo "vollibrespot cleared"
fi

## volspotconnect2
VOLSPOTCONNECT2_PATH=/data/plugins/music_service/volspotconnect2/
if [ -d $VOLSPOTCONNECT2_PATH ]; then
  echo "Clearing old volspotconnect2 plugin"
  systemctl stop volspotconnect2.service
  systemctl disable volspotconnect2.service
  rm -rf $VOLSPOTCONNECT2_PATH
  echo "volspotconnect2 plugin cleared"
fi

DAEMON_BASE_URL=https://github.com/devgianlu/go-librespot/releases/download/v
VERSION=0.0.11
DAEMON_ARCHIVE=go-librespot_linux_$ARCH.tar.gz
DAEMON_DOWNLOAD_URL=$DAEMON_BASE_URL$VERSION/$DAEMON_ARCHIVE
DAEMON_DOWNLOAD_PATH=/home/volumio/$DAEMON_ARCHIVE

echo "Dowloading daemon"
DAEMON_VOLUMIO_MODE=go-librespot-daemon.service
DAEMON_CONNECT_MODE=go-librespot-connect-daemon.service
systemctl stop ${DAEMON_VOLUMIO_MODE}
systemctl stop ${DAEMON_CONNECT_MODE}
wget $DAEMON_DOWNLOAD_URL -O $DAEMON_DOWNLOAD_PATH
tar xf $DAEMON_DOWNLOAD_PATH -C /usr/bin/ go-librespot
rm $DAEMON_DOWNLOAD_PATH
chmod a+x /usr/bin/go-librespot

echo 'Creating start script for Volumio mode'

LIBRESPOT_VOLUMIO_FILE=/bin/start-go-liberspot.sh
echo "#!/bin/sh
export GOTRACEBACK=crash
DAEMON_DATA_PATH=/data/go-librespot/
[ -d $DAEMON_DATA_PATH ] || mkdir $DAEMON_DATA_PATH
echo 'Starting librespot-go daemon for Volumio mode...'
/usr/bin/go-librespot -config_path /tmp/go-librespot-config.yml -credentials_path /data/configuration/music_service/spop/spotifycredentials.json" >${LIBRESPOT_VOLUMIO_FILE}
chmod a+x ${LIBRESPOT_VOLUMIO_FILE}

echo "[Unit]
Description = go-librespot daemon for Volumio mode
After = volumio.service
[Service]
ExecStart=${LIBRESPOT_VOLUMIO_FILE}
Restart=always
RestartSec=3
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=go-librespot
User=volumio
Group=volumio
[Install]
WantedBy=multi-user.target" >/lib/systemd/system/${DAEMON_VOLUMIO_MODE}

echo 'Creating start script for Connect mode'
LIBRESPOT_CONNECT_FILE=/bin/start-go-librespot-connect.sh
echo "#!/bin/sh
export GOTRACEBACK=crash
DAEMON_DATA_PATH=/data/go-librespot/
[ -d $DAEMON_DATA_PATH ] || mkdir $DAEMON_DATA_PATH
echo 'Starting librespot-go daemon for Connect mode...'
/usr/bin/go-librespot -config_path /tmp/go-librespot-connect-config.yml" >${LIBRESPOT_CONNECT_FILE}
chmod a+x ${LIBRESPOT_CONNECT_FILE}

echo "[Unit]
Description = go-librespot daemon for Connect mode
After = volumio.service
[Service]
ExecStart=${LIBRESPOT_CONNECT_FILE}
Restart=always
RestartSec=3
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=go-librespot-connect
User=volumio
Group=volumio
[Install]
WantedBy=multi-user.target" >/lib/systemd/system/${DAEMON_CONNECT_MODE}

systemctl daemon-reload

#required to end the plugin install
echo "plugininstallend"
