const express = require('express');
const { getFlowerTypes } = require('../controller/flowerType.controller');

const router = express.Router();

// Route to fetch colors
router.get('/flowerTypes', getFlowerTypes);

module.exports = router;
