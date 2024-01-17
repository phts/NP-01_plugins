#/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

for arg in "$@"; do
  if [ "$arg" == "podcast" ]; then
    PLUGIN_DIR="/data/plugins/music_service/podcast"
    scp "${SCRIPT_DIR}/../podcast/index.js" volumio-dev:${PLUGIN_DIR}/
    # scp "${SCRIPT_DIR}/../podcast/package.json" volumio-dev:${PLUGIN_DIR}/
  fi
  if [ "$arg" == "spotify" ]; then
    PLUGIN_DIR="/data/plugins/music_service/spop"
    scp "${SCRIPT_DIR}/../spotify/index.js" volumio-dev:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/helpers.js" volumio-dev:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/i18n/strings_en.json" volumio-dev:${PLUGIN_DIR}/i18n/
    scp "${SCRIPT_DIR}/../spotify/i18n/strings_ru.json" volumio-dev:${PLUGIN_DIR}/i18n/
    scp "${SCRIPT_DIR}/../spotify/package.json" volumio-dev:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/UIConfig.json" volumio-dev:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/config.yml.tmpl" volumio-dev:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/config-connect.yml.tmpl" volumio-dev:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/install.sh" volumio-dev:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/uninstall.sh" volumio-dev:${PLUGIN_DIR}/
    scp "${SCRIPT_DIR}/../spotify/utils/extendedSpotifyApi/fetchPagedData.js" volumio-dev:${PLUGIN_DIR}/utils/extendedSpotifyApi/
    scp "${SCRIPT_DIR}/../spotify/utils/extendedSpotifyApi/index.js" volumio-dev:${PLUGIN_DIR}/utils/extendedSpotifyApi/
    scp "${SCRIPT_DIR}/../spotify/utils/extendedSpotifyApi/rateLimitedCall.js" volumio-dev:${PLUGIN_DIR}/utils/extendedSpotifyApi/
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
  ssh volumio-dev "sudo -S bash '${PLUGIN_DIR}/install.sh'"
fi

if [ "${NEED_UNINSTALL}" == "true" ]; then
  ssh volumio-dev "sudo -S bash '${PLUGIN_DIR}/uninstall.sh'"
fi

if [ "${NEED_RESTART}" == "true" ]; then
  ssh volumio-dev 'sudo systemctl restart volumio'
  echo "Restarting..."
fi
