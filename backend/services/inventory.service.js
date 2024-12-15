// services/inventory.service.js

const Inventory = require('../model/inventory.model');

class InventoryService {
  async getInventoryByUsername(username) {
    return Inventory.findOne({ username });
  }
  async searchInventory({ 
    username, 
    flowerType, 
    color, 
    keyword, 
    page = 1, 
    limit = 10, 
    sortBy = 'flowerType', 
    order = 'asc' 
  }) {
    // Pagination variables
    const pageInt = parseInt(page, 10);
    const limitInt = parseInt(limit, 10);
    const skip = (pageInt - 1) * limitInt;
  
    // Sorting variables
    const sortOrder = order === 'desc' ? -1 : 1;
  
    // Find the inventory for the user
    const inventory = await Inventory.findOne({ username });
    if (!inventory) {
      throw new Error('Inventory not found.');
    }
  
    // Combine the filters
    const regex = keyword ? new RegExp(keyword, 'i') : null;
    let filteredFlowers = inventory.flowers.filter(flower => 
      (!flowerType || flower.flowerType.toLowerCase() === flowerType.toLowerCase()) &&
      (!color || flower.color.toLowerCase() === color.toLowerCase()) &&
      (!keyword || regex.test(flower.flowerType) || regex.test(flower.color) || regex.test(flower.careTips || ''))
    );
  
    // Sort the filtered flowers if a valid sortBy field exists
    if (sortBy && filteredFlowers.length > 0 && filteredFlowers[0][sortBy] !== undefined) {
      filteredFlowers = filteredFlowers.sort((a, b) =>
        a[sortBy]?.localeCompare(b[sortBy]) * sortOrder
      );
    }
  
    // Paginate results
    const paginatedFlowers = filteredFlowers.slice(skip, skip + limitInt);
  
    return {
      flowers: paginatedFlowers,
      total: filteredFlowers.length,
      page: pageInt,
      limit: limitInt,
    };
  }
  
  async addFlower(username, flowerData) {
    const inventory = await Inventory.findOne({ username });
  
    if (!inventory) {
      // If inventory doesn't exist, create a new one with the flower
      const newInventory = new Inventory({
        username,
        flowers: [flowerData],
      });
      await newInventory.save();
      return newInventory;
    }
  
    // Check if the flower type and color combination exists
    const flowerIndex = inventory.flowers.findIndex(
      (flower) => flower.type === flowerData.type && flower.color === flowerData.color
    );
  
    if (flowerIndex > -1) {
      // If the flower type and color combination exists, update its quantity
      inventory.flowers[flowerIndex].quantity += flowerData.quantity;
    } else {
      // Otherwise, add the new flower
      inventory.flowers.push(flowerData);
    }
  
    await inventory.save();
    return inventory;
  }
  

  async updateFlower(username, flowerId, updatedData) {
    const inventory = await Inventory.findOneAndUpdate(
      { username, 'flowers._id': flowerId },
      { $set: { 'flowers.$': updatedData } },
      { new: true }
    );
    return inventory;
  }

  async deleteFlower(username, flowerId) {
    const inventory = await Inventory.findOneAndUpdate(
      { username },
      { $pull: { flowers: { _id: flowerId } } },
      { new: true }
    );
    return inventory;
  }
}

module.exports = new InventoryService();
