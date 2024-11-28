const express = require('express');
const {
  fetchItems,
  addItem,
  createItemController,
  uploadImage,
  getItemById,
  fetchRecommendedItems,
  fetchItemsByTag,
  getTop4RatedItems,
  getTopRatedItems,
  fetchItemsByColor,
} = require('../controller/item.controller');

const router = express.Router();

router.get('/items', fetchItems);
router.post('/items', addItem);
router.post('/create', uploadImage, createItemController);
router.get('/items/:id', getItemById); // Route to fetch an item by ID
router.get('/items', fetchItems);
router.get('/items/tag/:tag',fetchItemsByTag);
router.get('/items/color/:color',fetchItemsByColor);
router.get('/top4-rated-items', getTop4RatedItems);
router.get('/top-rated-items', getTopRatedItems);

// Route to fetch recommended items

router.post('/recommendations', fetchRecommendedItems);

module.exports = router;
