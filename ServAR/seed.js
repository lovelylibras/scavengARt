const { db } = require('./server/db');
const { green, red } = require('chalk');

const Hunts = require('./server/db/models/hunts');
const Paintings = require('./server/db/models/paintings');

const seed = async () => {
  await db.sync({ force: true });

  const metropolitanHunt = await Hunts.create({
    name: 'Metropolitan Museum of Art Hunt',
    description: 'Learn about the Metropolitan Museum of Art',
  });

  const paintings = [
    {
      name: 'Madame X',
      artist: 'John Singer Sargent',
      imageUrl:
        'https://collectionapi.metmuseum.org/api/collection/v1/iiif/12127/33591/restricted',
      museum: 'Metropolitan Museum of Art',
      huntId: metropolitanHunt.id,
    },
    {
      name: 'Portrait of Theo van Gogh',
      artist: 'Vincent van Gogh',
      imageUrl:
        'https://collectionapi.metmuseum.org/api/collection/v1/iiif/436532/1671316/main-image',
      museum: 'Metropolitan Museum of Art',
      huntId: metropolitanHunt.id,
    },
    {
      name: 'Springtime',
      artist: 'Pierre-Auguste Cot',
      imageUrl:
        'https://collectionapi.metmuseum.org/api/collection/v1/iiif/438158/799953/main-image',
      museum: 'Metropolitan Museum of Art',
      huntId: metropolitanHunt.id,
    },
  ];

  await Promise.all(
    paintings.map(painting => {
      return Paintings.create(painting);
    })
  );

  console.log(green('Seeding success!'));
  db.close();
};

seed().catch(err => {
  console.error(red('Oh noes! Something went wrong!'));
  console.error(err);
  db.close();
});
