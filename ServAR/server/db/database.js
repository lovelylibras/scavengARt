const chalk = require('chalk');
const Sequelize = require('sequelize');
const pkg = require('../../package.json');

console.log(chalk.yellow('Opening database connection'));

// create the database instance that can be used in other database files

const databaseUrl =
  process.env.DATABASE_URL || `postgres://localhost:5432/${pkg.name}`;
const db = new Sequelize(databaseUrl, {
  logging: false,
  operatorsAliases: false,
});
module.exports = db;
