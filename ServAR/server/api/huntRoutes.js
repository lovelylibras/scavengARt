const router = require('express').Router();
const Hunts = require('../db/models/hunts');
const Paintings = require('../db/models/paintings');

router.get('/', async (req, res, next) => {
  try {
    const allHunts = await Hunts.findAll();
    if (allHunts) {
      res.status(200).send(allHunts);
    } else {
      next();
    }
  } catch (error) {
    next(error);
  }
});

router.get('/:huntId', async (req, res, next) => {
  try {
    const selectedHunt = await Hunts.findByPk(req.params.huntId, {
      include: { model: Paintings },
    });
    if (selectedHunt) {
      res.status(200).send(selectedHunt);
    } else {
      next();
    }
  } catch (error) {
    next(error);
  }
});

router.post('/', async (req, res, next) => {
  try {
    const newHunt = await Hunts.create(req.body);
    res.status(201).send(newHunt);
  } catch (error) {
    next(error);
  }
});

router.delete('/:huntId', async (req, res, next) => {
  try {
    const selectedHunt = await Hunts.findByPk(req.params.huntId);
    if (selectedHunt) {
      await selectedHunt.destroy();
      res.status(204).send('Success');
    } else {
      next();
    }
  } catch (error) {
    next(error);
  }
});

router.put('/:huntId', async (req, res, next) => {
  try {
    let selectedHunt = await Hunts.findByPk(req.params.huntId);
    if (selectedHunt) {
      selectedHunt.update(req.body);
      res.status(200).send(selectedHunt);
    } else {
      next();
    }
  } catch (error) {
    next(error);
  }
});

module.exports = router;
