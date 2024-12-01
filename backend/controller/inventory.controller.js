// controllers/inventory.controller.js

const InventoryService = require('../services/inventory.service');
const InventoryModel = require('../model/inventory.model');

class InventoryController {
  async getInventory(req, res) {
    const { username } = req.params;
    // try {
    //   const inventory = await InventoryService.getInventoryByUsername(username);
    //   res.status(200).json(inventory);
    // } catch (error) {
    //   res.status(500).json({ error: 'Failed to fetch inventory.' });
    // }
    try {
      // Check if inventory exists
      let inventory = await InventoryModel.findOne({ username });
  
      // If no inventory exists, create one
      if (!inventory) {
        inventory = new InventoryModel({
          username,
          flowers: [], // Default empty inventory
        });
        await inventory.save();
      }
  
      res.status(200).json(inventory);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Server error. Please try again later.' });
    }
  }

  async addFlower(req, res) {
    const { username } = req.params;
    const flowerData = req.body;
    let image = '';

    // Handle profile photo URL if a file is uploaded
    if (req.file) {
      image = `${req.protocol}://${req.get('host')}/uploadsFlowers/${req.file.filename}`;
      flowerData.image = image;  // Add image URL to flowerData object

    }

    flowerData.quantity = Number(flowerData.quantity);
    console.log('Incoming flowerData:', flowerData);

  
    try {
      const updatedInventory = await InventoryService.addFlower(username, flowerData);
      res.status(200).json(updatedInventory);
    } catch (error) {
      res.status(500).json({ error: 'Failed to add flower.' });
    }
  }
  
  

  async updateFlower(req, res) {
    const { username, flowerId } = req.params;
    const updatedData = req.body;
    try {
      const updatedInventory = await InventoryService.updateFlower(username, flowerId, updatedData);
      res.status(200).json(updatedInventory);
    } catch (error) {
      res.status(500).json({ error: 'Failed to update flower.' });
    }
  }

  async deleteFlower(req, res) {
    const { username, flowerId } = req.params;
    try {
      const updatedInventory = await InventoryService.deleteFlower(username, flowerId);
      res.status(200).json(updatedInventory);
    } catch (error) {
      res.status(500).json({ error: 'Failed to delete flower.' });
    }
  }
  async searchInventory(req, res) {
    const { username } = req.params;
    const { flowerType, color, keyword, page = 1, limit = 10, sortBy = 'flowerType', order = 'asc' } = req.query;
  
    try {
      const result = await InventoryService.searchInventory({
        username,
        flowerType,
        color,
        keyword,
        page,
        limit,
        sortBy,
        order,
      });
  
      res.status(200).json(result);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Server error. Please try again later.' });
    }
  }
}

module.exports = new InventoryController();
