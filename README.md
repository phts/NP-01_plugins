# PHTS NP-01: Plugins

Modified [Volumio plugins][volumio-plugins-sources] which are used by [PHTS NP-01].

## Changes

Go to each plugin's README for noticeable changes:

- [peppymeterbasic]
- [podcast]
- [spotify]

### Changelog by git

```sh
git remote add v https://github.com/volumio/volumio3-backend.git
git fetch v
PLUGIN="spotify" # or podcast

git log v/master..origin/master --oneline | grep "(${PLUGIN})" | grep -v "style(" | grep -v "style:" | grep -v "chore("
```

## Sync with original repo

```sh
git remote add v https://github.com/volumio/volumio3-backend.git
git fetch v

git checkout volumio-master-formatted
git merge v/master
# in case of conflicts:
  git checkout v/master -- "**/*"
  # and remove all plugins except listed above

npm run format
git add .
git commit

git checkout master
git merge volumio-master-formatted
# fix conflicts, run format and commit
```

## Deploy

```sh
bash scripts/deploy.sh [podcast|spotify] [--install] [--uninstall] [--restart]
```

Use `--install` to run `install.sh` script, e.g. to install updated `go-librespot` library

### Prerequisites

1. Configure `ssh` host `volumio` pointing to your device
2. Install original Spotify plugin on your device, because "deploy" script will override some files of original plugin

[phts np-01]: https://tsaryk.com/NP-01
[volumio-plugins-sources]: https://github.com/volumio/volumio-plugins-sources
[spotify]: ./spotify
[podcast]: ./podcast
