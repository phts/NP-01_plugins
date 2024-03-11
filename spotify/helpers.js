module.exports.parseYear = (album) => (album && album.release_date ? album.release_date.split('-')[0] : null);

module.exports.tracksTotalDiscs = (tracks) => {
  const discs = {};
  tracks.forEach((tr) => {
    discs[tr.discnumber || 1] = true;
  });
  return Object.keys(discs).length;
};
