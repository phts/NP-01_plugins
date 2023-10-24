module.exports.parseYear = (album) => (album && album.release_date ? album.release_date.split('-')[0] : null);
