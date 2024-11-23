const express = require('express');
const {
  fetchItems,
  addItem,
  createItemController,
  uploadImage,
  getItemById,
  fetchRecommendedItems,
} = require('../controller/bouqet.controller');

const router = express.Router();

router.get('/bouqets', fetchItems);
router.post('/bouqets', addItem);
router.post('/create', uploadImage, createItemController);
router.get('/bouqets/:id', getItemById); // Route to fetch an item by ID
router.post('/recommendations', fetchRecommendedItems);

module.exports = router;
