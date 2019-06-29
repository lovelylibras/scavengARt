const Sequelize = require('sequelize');
const db = require('../database');

const Paintings = db.define('painting', {
  name: {
    type: Sequelize.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
    },
  },
  artist: {
    type: Sequelize.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
    },
  },
  imageUrl: {
    type: Sequelize.STRING,
    defaultValue:
      'https://static.dezeen.com/uploads/2016/02/new-metropolitan-art-museum-logo-wolff-olins_dezeen_1568_0.jpg',
  },
  museum: {
    type: Sequelize.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
    },
  },
});

module.exports = Paintings;
