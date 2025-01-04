const express = require('express');
const { getFlowerTypes,deleteFlowerType,addFlowerType } = require('../controller/flowerType.controller');

const router = express.Router();

// Route to fetch colors
router.get('/flowerTypes', getFlowerTypes);
router.delete('/delete/:id', deleteFlowerType);
router.post('/add', addFlowerType);
module.exports = router;
