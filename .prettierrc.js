'use strict';
const config = require('@phts/prettier-config');

module.exports = {
  ...config,
  semi: true,
  overrides: [
    {
      files: 'spotify/index.js',
      options: {
        // to avoid a lot of conflicts with original file
        tabWidth: 4,
      },
    },
  ],
};
