function parseSortingParams(uri, defaultParams) {
  const url = new URL(`mock://${uri}`);
  return {
    ...Object.assign({}, defaultParams, Object.fromEntries(url.searchParams)),
    enabled: Array.from(url.searchParams.keys()).length > 0,
  };
}

const comparators = {
  byLocalizedString: (a, b) => a.localeCompare(b, undefined, {sensitivity: 'base'}),
  byAny: (a, b) => (a > b ? 1 : a === b ? 0 : -1),
  byTitle: {
    asc: () => (a, b) => a.title.localeCompare(b.title, undefined, {sensitivity: 'base'}),
    desc: () => (b, a) => a.title.localeCompare(b.title, undefined, {sensitivity: 'base'}),
  },
  byProp: {
    asc: (prop) => (a, b) => (a[prop] > b[prop] ? 1 : a[prop] === b[prop] ? 0 : -1),
    desc: (prop) => (b, a) => (a[prop] > b[prop] ? 1 : a[prop] === b[prop] ? 0 : -1),
  },
  byAlbumArtist: {
    asc: () => (a, b) => {
      if (a.artist !== b.artist) {
        return a.artist.localeCompare(b.artist, undefined, {sensitivity: 'base'});
      }
      return a.year > b.year ? 1 : a.year === b.year ? 0 : -1;
    },
    desc: () => (a, b) => {
      if (a.artist !== b.artist) {
        return b.artist.localeCompare(a.artist, undefined, {sensitivity: 'base'});
      }
      return a.year < b.year ? 1 : a.year === b.year ? 0 : -1;
    },
  },
  byTrackArtist: {
    asc: () => (a, b) => {
      if (a.artist !== b.artist) {
        return a.artist.localeCompare(b.artist, undefined, {sensitivity: 'base'});
      }
      if (a.year !== b.year) {
        return a.year > b.year ? 1 : -1;
      }
      if (a.album !== b.album) {
        return a.album > b.album ? 1 : -1;
      }
      return a.tracknumber > b.tracknumber ? 1 : a.tracknumber === b.tracknumber ? 0 : -1;
    },
    desc: () => (a, b) => {
      if (a.artist !== b.artist) {
        return b.artist.localeCompare(a.artist, undefined, {sensitivity: 'base'});
      }
      if (a.year !== b.year) {
        return a.year > b.year ? 1 : -1;
      }
      if (a.album !== b.album) {
        return a.album > b.album ? 1 : -1;
      }
      return a.tracknumber > b.tracknumber ? 1 : a.tracknumber === b.tracknumber ? 0 : -1;
    },
  },
};

const sorters = {
  artists: {
    name: {
      asc: (a, b) => comparators.byLocalizedString(a.title, b.title),
      desc: (a, b) => comparators.byLocalizedString(b.title, a.title),
    },
    dateAdded: {
      asc: () => -1,
      desc: () => 0,
    },
  },
  albums: {
    name: {
      asc: (a, b) => comparators.byLocalizedString(a.title, b.title),
      desc: (a, b) => comparators.byLocalizedString(b.title, a.title),
    },
    releaseDate: {
      asc: (a, b) => comparators.byAny(a.year, b.year),
      desc: (a, b) => comparators.byAny(b.year, a.year),
    },
    dateAdded: {
      asc: (a, b) => comparators.byAny(a.addedAt, b.addedAt),
      desc: (a, b) => comparators.byAny(b.addedAt, a.addedAt),
    },
    artist: {
      asc: (a, b) => {
        if (a.artist !== b.artist) {
          return comparators.byLocalizedString(a.artist, b.artist);
        }
        return comparators.byAny(a.year, b.year);
      },
      desc: (a, b) => {
        if (a.artist !== b.artist) {
          return comparators.byLocalizedString(b.artist, a.artist);
        }
        return comparators.byAny(a.year, b.year);
      },
    },
  },
  tracks: {
    name: {
      asc: (a, b) => comparators.byLocalizedString(a.title, b.title),
      desc: (a, b) => comparators.byLocalizedString(b.title, a.title),
    },
    dateAdded: {
      asc: (a, b) => comparators.byAny(a.addedAt, b.addedAt),
      desc: (a, b) => comparators.byAny(b.addedAt, a.addedAt),
    },
    artist: {
      asc: (a, b) => {
        if (a.artist !== b.artist) {
          return comparators.byLocalizedString(a.artist, b.artist);
        }
        if (a.year !== b.year) {
          return comparators.byAny(a.year, b.year);
        }
        if (a.album !== b.album) {
          return comparators.byAny(a.album, b.album);
        }
        return comparators.byAny(a.tracknumber, b.tracknumber);
      },
      desc: (a, b) => {
        if (a.artist !== b.artist) {
          return comparators.byLocalizedString(b.artist, a.artist);
        }
        if (a.year !== b.year) {
          return comparators.byAny(a.year, b.year);
        }
        if (a.album !== b.album) {
          return comparators.byAny(a.album, b.album);
        }
        return comparators.byAny(a.tracknumber, b.tracknumber);
      },
    },
  },
  playlists: {
    name: {
      asc: (a, b) => comparators.byLocalizedString(a.title, b.title),
      desc: (a, b) => comparators.byLocalizedString(b.title, a.title),
    },
    dateAdded: {
      asc: () => -1,
      desc: () => 0,
    },
  },
};

module.exports = {
  parseSortingParams,
  sorters,
};
