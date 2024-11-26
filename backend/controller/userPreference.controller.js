const { initializeUserPreference, updateUserPreference,checkUserPreferenceExists  } = require('../services/userPreference.service');
const UserPreference = require('../model/userPreference.model'); // Adjust path as needed


// Controller to check if a user preference exists
const checkUserPreferenceExistsController = async (req, res) => {
  try {
    const { username } = req.params;
    const exists = await checkUserPreferenceExists(username);

    if (exists) {
      return res.status(200).json({ message: 'User preferences exist' });
    }
    return res.status(404).json({ message: 'User preferences not found' });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

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
    const { username, color, flowerType } = req.body;
    const updatedPreference = await updateUserPreference(
      username,
      color || [],
      flowerType || []
    );
    res.status(200).json(updatedPreference);
  } catch (error) {
    res.status(500).json({ message: 'Error updating user preferences', error: error.message });
  }
};


// Controller function to fetch flower types by username
const getFlowerTypes = async (req, res) => {
  try {
    const { username } = req.params;
    const userPreference = await UserPreference.findOne({ username });

    if (!userPreference) {
      return res.status(404).json({ message: 'User preferences not found' });
    }

    res.json(userPreference.flowerType);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error });
  }
};

module.exports = { initializeUserPreferenceController, updateUserPreferenceController,getFlowerTypes ,checkUserPreferenceExistsController};
