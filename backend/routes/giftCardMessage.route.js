const express = require('express');
const { giftCardMessage } = require('../controller/giftCardMessage.controller');

const router = express.Router();

// POST endpoint to generate a gift card message
router.post('/generate-giftCardMessage', giftCardMessage);

module.exports = router;
