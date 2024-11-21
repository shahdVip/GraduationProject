const { initializeUserPreference, updateUserPreference } = require('../services/userPreference.service');

// Controller for initializing user preferences
const initializeUserPreferenceController = async (req, res) => {
  try {
    const { username } = req.body;
    const userPreference = await initializeUserPreference(username);
    res.status(200).json(userPreference);
  } catch (error) {
    res.status(500).json({ message: 'Error initializing user preferences', error: error.message });
  }
};

// Controller for updating user preferences
const updateUserPreferenceController = async (req, res) => {
  try {
    const { username, color, flowerType, tag } = req.body;
    const updatedPreference = await updateUserPreference(username, color, flowerType, tag);
    res.status(200).json(updatedPreference);
  } catch (error) {
    res.status(500).json({ message: 'Error updating user preferences', error: error.message });
  }
};

module.exports = { initializeUserPreferenceController, updateUserPreferenceController };
