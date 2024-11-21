// routes/userRequest.routes.js
const express = require('express');
const router = express.Router();
const userRequestController = require('../controller/userRequest.controller');

router.post('/create', userRequestController.createUserRequest);
router.get('/all', userRequestController.getUserRequests);
router.post('/approve', userRequestController.approveUser);
router.post('/deny', userRequestController.denyUser);

module.exports = router;
