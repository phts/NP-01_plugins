# PHTS NP-01: Plugins

Modified [Volumio plugins][volumio-plugins-sources] which are used by [PHTS NP-01].

Contains:

- [podcast]
- [spotify]

## Differences comparing to original plugins

```sh
git remote add v https://github.com/volumio/volumio3-backend.git
git fetch v
PLUGIN="spotify" # or podcast

git log v/master..origin/master --no-merges --oneline | grep "(${PLUGIN})" | grep -v "style(" | grep -v "style:" | grep -v "chore("
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

[phts np-01]: https://tsaryk.com/NP-01
[volumio-plugins-sources]: https://github.com/volumio/volumio-plugins-sources
[spotify]: './spotify
[podcast]: './podcast
