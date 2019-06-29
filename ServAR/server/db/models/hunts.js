const Sequelize = require('sequelize');
const db = require('../database');

const Hunts = db.define('hunt', {
  name: {
    type: Sequelize.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
    },
  },
  description: {
    type: Sequelize.TEXT,
  },
});

module.exports = Hunts;
