const FlowerType = require('../model/flowerType.model');

// Controller to fetch all colors
const getFlowerTypes = async (req, res) => {
  try {
    const flowerTypes = await FlowerType.find();

    res.status(200).json(flowerTypes);
  } catch (err) {
    console.error('Error fetching flower types:', err);
    res.status(500).json({ error: 'Failed to fetch flower types' });
  }
};
 const deleteFlowerType = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await FlowerType.findByIdAndDelete(id);
    if (result) {
      res.status(200).json({ message: 'Flower type deleted successfully' });
    } else {
      res.status(404).json({ message: 'Flower type not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error deleting flower type', error });
  }
};
const addFlowerType = async (req, res) => {
  try {
    const { flowerType } = req.body;

    if (!flowerType) {
      return res.status(400).json({ message: 'Flower type is required' });
    }

    // Check for duplicate
    const existingFlowerType = await FlowerType.findOne({ flowerType });
    if (existingFlowerType) {
      return res.status(400).json({ message: 'Flower type already exists' });
    }

    // Create a new flower type
    const newFlowerType = await FlowerType.create({ flowerType });

    res.status(201).json({
      message: 'Flower type added successfully',
      data: newFlowerType,
    });
  } catch (error) {
    console.error('Error adding flower type:', error); // Log the error
    res.status(500).json({ message: 'Error adding flower type' });
  }
};


module.exports = { getFlowerTypes ,deleteFlowerType,addFlowerType};