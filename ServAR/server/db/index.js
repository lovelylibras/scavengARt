'use strict';

const db = require('./database');
const Hunts = require('./models/hunts');
const Paintings = require('./models/paintings');

Paintings.belongsTo(Hunts);
Hunts.hasMany(Paintings);

module.exports = {
  // Include your models in this exports object as well!
  db,
  Hunts,
  Paintings,
};
