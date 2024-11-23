const express = require('express');
const {
  fetchItems,
  addItem,
  createItemController,
  uploadImage,
  getItemById,
  fetchRecommendedItems,
} = require('../controller/item.controller');

const router = express.Router();

router.get('/items', fetchItems);
router.post('/items', addItem);
router.post('/create', uploadImage, createItemController);
router.get('/items/:id', getItemById); // Route to fetch an item by ID
router.post('/recommendations', fetchRecommendedItems);

module.exports = router;
