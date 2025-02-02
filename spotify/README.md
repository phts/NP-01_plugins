# Spotify plugin

Tweaks made to [the original plugin](https://github.com/volumio/volumio-plugins-sources/tree/master/spotify):

- State:
  - Album's year
  - Favorite track flag
- Media library:
  - Show album's year
  - Fetch all items in "My tracks" and "My albums"
  - Sort tracks and albums in more intuitive order
  - Add "Followed artists" page
  - Fetch localized artist names based on current Volumio locale
  - Mark favorite tracks/albums
    - Favorite albums require UI support, however official Manifest UI theme does not support favorite marks on albums. I have my customized Manifest UI theme instead.
- Artist's page
  - Reorder "albums", "EPs", etc into separate lists
  - "Favorite tracks" item
  - Move "Top tracks", "Appears on" and "Related artists" into separate pages to speed up the page loading
- Connect mode:
  - Support "go to artist/album"
  - Show track number and year
- Settings:
  - Option "Disable normalization"
- Global:
  - Fix a lot of mistakes and cleaned up dead code found by ESLint/Prettier
