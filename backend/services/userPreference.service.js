const UserPreferenceModel = require('../model/userPreference.model');

// Service for initializing user preferences
const initializeUserPreference = async (username) => {
  // Check if a preference document already exists
  let userPreference = await UserPreferenceModel.findOne({ username });
  if (!userPreference) {
    // If not, create a new one with empty arrays
    userPreference = new UserPreferenceModel({ username });
    await userPreference.save();
  }
  return userPreference;
};

// Service for updating user preferences
const updateUserPreference = async (username, color, flowerType, tags) => {
  // Find the user's preference document
  const userPreference = await UserPreferenceModel.findOne({ username });
  if (!userPreference) {
    throw new Error('User preference not found');
  }

  // Add color and flowerType to arrays if not already present
  if (color && !userPreference.colors.includes(color)) {
    userPreference.colors.push(color);
  }
  if (flowerType && !userPreference.flowerType.includes(flowerType)) {
    userPreference.flowerType.push(flowerType);
  }

  // Add multiple tags if they are not already present
  if (tags && Array.isArray(tags)) {
    tags.forEach(tag => {
      if (!userPreference.tags.includes(tag)) {
        userPreference.tags.push(tag);
      }
    });
  }

  // Save the updated document
  await userPreference.save();
  return userPreference;
};


module.exports = { initializeUserPreference, updateUserPreference };
