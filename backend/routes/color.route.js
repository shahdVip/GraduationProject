const express = require('express');
const { getColors } = require('../controller/color.controller');

const router = express.Router();

// Route to fetch colors
router.get('/colors', getColors);

module.exports = router;
