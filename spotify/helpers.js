module.exports.parseYear = (obj) => (obj && obj.release_date ? obj.release_date.split('-')[0] : null);
