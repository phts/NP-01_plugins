#/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

for arg in "$@"; do
  if [ "$arg" == "podcast" ]; then
    scp "${SCRIPT_DIR}/../podcast/index.js" volumio:/data/plugins/music_service/podcast/
    # scp "${SCRIPT_DIR}/../podcast/package.json" volumio:/data/plugins/music_service/podcast/
  fi
  if [ "$arg" == "spotify" ]; then
    scp "${SCRIPT_DIR}/../spotify/index.js" volumio:/data/plugins/music_service/spop/
    # scp "${SCRIPT_DIR}/../spotify/helpers.js" volumio:/data/plugins/music_service/spop/
    # scp "${SCRIPT_DIR}/../spotify/i18n/strings_en.json" volumio:/data/plugins/music_service/spop/i18n/
    # scp "${SCRIPT_DIR}/../spotify/i18n/strings_ru.json" volumio:/data/plugins/music_service/spop/i18n/
    # scp "${SCRIPT_DIR}/../spotify/package.json" volumio:/data/plugins/music_service/spop/
    # scp "${SCRIPT_DIR}/../spotify/UIConfig.json" volumio:/data/plugins/music_service/spop/
    # scp "${SCRIPT_DIR}/../spotify/config.yml.tmpl" volumio:/data/plugins/music_service/spop/
    # scp "${SCRIPT_DIR}/../spotify/install.sh" volumio:/data/plugins/music_service/spop/
    # scp "${SCRIPT_DIR}/../spotify/utils/extendedSpotifyApi/fetchPagedData.js" volumio:/data/plugins/music_service/spop/utils/extendedSpotifyApi/
    # scp "${SCRIPT_DIR}/../spotify/utils/extendedSpotifyApi/index.js" volumio:/data/plugins/music_service/spop/utils/extendedSpotifyApi/
    # scp "${SCRIPT_DIR}/../spotify/utils/extendedSpotifyApi/rateLimitedCall.js" volumio:/data/plugins/music_service/spop/utils/extendedSpotifyApi/
  fi
  if [ "$arg" == "--restart" ]; then
    NEED_RESTART=true
  fi
done

if [ "$NEED_RESTART" == "true" ]; then
  ssh volumio 'sudo systemctl restart volumio'
  echo "Restarting..."
fi
