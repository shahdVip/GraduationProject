const flowerType = require('../model/flowerType.model');

// Controller to fetch all colors
const getFlowerTypes = async (req, res) => {
  try {
    const flowerTypes = await flowerType.find();

    res.status(200).json(flowerTypes);
  } catch (err) {
    console.error('Error fetching flower types:', err);
    res.status(500).json({ error: 'Failed to fetch flower types' });
  }
};

module.exports = { getFlowerTypes };