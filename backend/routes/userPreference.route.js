const express = require('express');
const {
  initializeUserPreferenceController,
  updateUserPreferenceController
} = require('../controller/userPreference.controller');

const router = express.Router();

// Route to initialize user preferences
router.post('/initialize-preference', initializeUserPreferenceController);

// Route to update user preferences
router.put('/update-preference', updateUserPreferenceController);

module.exports = router;
