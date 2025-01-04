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
const deleteColor = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await Color.findByIdAndDelete(id);
    if (result) {
      res.status(200).json({ message: 'Color deleted successfully' });
    } else {
      res.status(404).json({ message: 'Color not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error deleting color', error });
  }
};
const addColor = async (req, res) => {
  try {
    const { color } = req.body;
    if (!color) {
      return res.status(400).json({ message: 'Color is required' });
    }
    const newColor = await Color.create({ color });
    res.status(201).json({ message: 'Color added successfully', data: newColor });
  } catch (error) {
    res.status(500).json({ message: 'Error adding color', error });
  }
};
module.exports = { getColors,deleteColor,addColor };