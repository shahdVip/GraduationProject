const express = require('express');
const { getTags } = require('../controller/tag.controller');

const router = express.Router();

// Route to fetch colors
router.get('/tags', getTags);

module.exports = router;
