const Color = require('../model/color.model');

// Controller to fetch all colors
const getColors = async (req, res) => {
  try {
    const colors = await Color.find(); // Fetch all color documents
    res.status(200).json(colors);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch colors' });
  }
};

module.exports = { getColors };