// routes/inventory.routes.js

const express = require('express');
const InventoryController = require('../controller/inventory.controller');

const router = express.Router();
const multer = require('multer');

// Configure Multer to store images in the 'uploads' folder
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploadsFlowers/'); // The folder where images will be stored
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname); // Unique filename
  },
});

const upload = multer({ storage });

// Fetch inventory for a business
router.get('/:username', InventoryController.getInventory);

// Add a new flower to the inventory
router.post('/:username/flowers', upload.single('image'),InventoryController.addFlower);

// Update a flower in the inventory
router.put('/:username/flowers/:flowerId', InventoryController.updateFlower);

// Delete a flower from the inventory
router.delete('/:username/flowers/:flowerId', InventoryController.deleteFlower);

// Search inventory with pagination, sorting, and case-insensitivity
router.get('/:username/search', InventoryController.searchInventory);


module.exports = router;
