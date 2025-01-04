const express = require('express');
const { getColors,deleteColor,addColor } = require('../controller/color.controller');

const router = express.Router();

// Route to fetch colors
router.get('/colors', getColors);
router.delete('/delete/:id', deleteColor);
router.post('/add', addColor);
module.exports = router;
