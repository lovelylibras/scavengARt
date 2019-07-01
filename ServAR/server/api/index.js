'use strict';

const router = require('express').Router();

router.use('/hunt', require('./huntRoutes'));
router.use('/painting', require('./paintingRoutes'))

router.use((req, res, next) => {
  const err = new Error('API route not found!');
  err.status = 404;
  next(err);
});

module.exports = router;
