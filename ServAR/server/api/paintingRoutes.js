const router = require('express').Router();
const Paintings = require('../db/models/paintings');
const Hunts = require('../db/models/hunts');

router.get('/', async (req, res, next) => {
  try {
    const allPaintings = await Paintings.findAll();
    if (allPaintings) {
      res.status(200).send(allPaintings);
    } else {
      next();
    }
  } catch (error) {
    next(error);
  }
});

router.get('/:paintingId', async (req, res, next) => {
  try {
    const selectedPainting = await Paintings.findByPk(req.params.paintingId, {
      include: {
        model: Hunts,
      },
    });
    if (selectedPainting) {
      res.status(200).send(selectedPainting);
    } else {
      next();
    }
  } catch (error) {
    next(error);
  }
});

router.post('/', async (req, res, next) => {
  try {
    const newPainting = await Paintings.create(req.body);
    res.status(201).send(newPainting);
  } catch (error) {
    next(error);
  }
});

router.delete('/:paintingId', async (req, res, next) => {
  try {
    const selectedPainting = await Paintings.findByPk(req.params.paintingId);
    if (selectedPainting) {
      selectedPainting.destroy();
      res.status(204).send('Success');
    } else {
      next();
    }
  } catch (error) {
    next(error);
  }
});

router.put('/:paintingId', async (req, res, next) => {
  try {
    const selectedPainting = await Paintings.findByPk(req.params.paintingId);
    if (selectedPainting) {
      selectedPainting.update(req.body);
      res.status(200).send(selectedPainting);
    } else {
      next();
    }
  } catch (error) {
    next(error);
  }
});

module.exports = router;
