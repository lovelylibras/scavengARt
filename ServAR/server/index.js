'use strict';

const express = require('express');

const app = express();

// body parsing middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api', require('./api')); // include our routes!

// error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).send(err.message || 'Internal server error');
});

module.exports = app;
