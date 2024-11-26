const express = require('express');
const {
  initializeUserPreferenceController,
  updateUserPreferenceController,
  getFlowerTypes,
  checkUserPreferenceExistsController

} = require('../controller/userPreference.controller');

const router = express.Router();

// Route to initialize user preferences
router.post('/initialize-preference', initializeUserPreferenceController);

// Route to update user preferences
router.put('/update-preference', updateUserPreferenceController);
// Define the route for fetching flower types by username
router.get('/fTypes/:username', getFlowerTypes);

router.get('/preference-exists/:username', checkUserPreferenceExistsController);

module.exports = router;
