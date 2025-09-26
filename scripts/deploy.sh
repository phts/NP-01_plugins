#/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

for arg in "$@"; do
  if [ "$arg" == "peppymeterbasic" ]; then
    PLUGIN_DIR="/data/plugins/user_interface/peppymeterbasic"
    scp "${SCRIPT_DIR}/../peppymeterbasic/config.json" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../peppymeterbasic/config.txt.tmpl" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../peppymeterbasic/index.js" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../peppymeterbasic/install.sh" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../peppymeterbasic/package.json" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../peppymeterbasic/UIConfig.json" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../peppymeterbasic/asound/peppy_in.peppy_out.6.conf" volumio:${PLUGIN_DIR}/asound/
    scp "${SCRIPT_DIR}/../peppymeterbasic/i18n/strings_en.json" volumio:${PLUGIN_DIR}/i18n/
  fi
  if [ "$arg" == "podcast" ]; then
    PLUGIN_DIR="/data/plugins/music_service/podcast"
    scp "${SCRIPT_DIR}/../podcast/index.js" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../podcast/package.json" volumio:${PLUGIN_DIR}/
  fi
  if [ "$arg" == "spotify" ]; then
    PLUGIN_DIR="/data/plugins/music_service/spop"
    scp "${SCRIPT_DIR}/../spotify/index.js" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/i18n/strings_en.json" volumio:${PLUGIN_DIR}/i18n/
    scp "${SCRIPT_DIR}/../spotify/i18n/strings_ru.json" volumio:${PLUGIN_DIR}/i18n/
    scp "${SCRIPT_DIR}/../spotify/package.json" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/UIConfig.json" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/config.yml.tmpl" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/install.sh" volumio:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/helpers/index.js" volumio:${PLUGIN_DIR}/helpers/
    scp "${SCRIPT_DIR}/../spotify/helpers/sorting.js" volumio:${PLUGIN_DIR}/helpers/
    scp "${SCRIPT_DIR}/../spotify/utils/extendedSpotifyApi/fetchByChunks.js" volumio:${PLUGIN_DIR}/utils/extendedSpotifyApi/
    scp "${SCRIPT_DIR}/../spotify/utils/extendedSpotifyApi/fetchPagedData.js" volumio:${PLUGIN_DIR}/utils/extendedSpotifyApi/
    scp "${SCRIPT_DIR}/../spotify/utils/extendedSpotifyApi/index.js" volumio:${PLUGIN_DIR}/utils/extendedSpotifyApi/
    scp "${SCRIPT_DIR}/../spotify/utils/extendedSpotifyApi/rateLimitedCall.js" volumio:${PLUGIN_DIR}/utils/extendedSpotifyApi/
  fi
  if [ "$arg" == "--npm-install" ]; then
    NEED_NPM_INSTALL=true
  fi
  if [ "$arg" == "--install" ]; then
    NEED_INSTALL=true
  fi
  if [ "$arg" == "--uninstall" ]; then
    NEED_UNINSTALL=true
  fi
  if [ "$arg" == "--restart" ]; then
    NEED_RESTART=true
  fi
done

if [ "${NEED_INSTALL}" == "true" ]; then
  ssh volumio "sudo -S bash '${PLUGIN_DIR}/install.sh'"
fi

if [ "${NEED_NPM_INSTALL}" == "true" ]; then
  ssh volumio "cd '${PLUGIN_DIR}' && sudo -S npm i"
fi

if [ "${NEED_UNINSTALL}" == "true" ]; then
  ssh volumio "sudo -S bash '${PLUGIN_DIR}/uninstall.sh'"
fi

if [ "${NEED_RESTART}" == "true" ]; then
  ssh volumio 'sudo systemctl restart volumio'
  echo "Restarting..."
fi
