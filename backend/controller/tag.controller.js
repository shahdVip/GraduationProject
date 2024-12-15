const Tag = require('../model/tag.model');

// Controller to fetch all colors
const getTags = async (req, res) => {
  try {
    const tags = await Tag.find(); // Fetch all tag documents
    res.status(200).json(tags);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch tags' });
  }
};

module.exports = { getTags };