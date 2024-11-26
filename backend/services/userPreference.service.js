const UserPreferenceModel = require('../model/userPreference.model');

const checkUserPreferenceExists = async (username) => {
  const userPreference = await UserPreferenceModel.findOne({ username });
  return !!userPreference; // Return true if userPreference exists, otherwise false
};

// Service for initializing user preferences
const initializeUserPreference = async (username) => {
  let userPreference = await UserPreferenceModel.findOne({ username });
  if (!userPreference) {
    userPreference = new UserPreferenceModel({ username });
    await userPreference.save();
  }
  return userPreference;
};

// Service for updating user preferences
const updateUserPreference = async (username, colors, flowerTypes, tags) => {
  const userPreference = await UserPreferenceModel.findOne({ username });
  if (!userPreference) {
    throw new Error('User preference not found');
  }

  // Add colors to array if not already present
  if (Array.isArray(colors)) {
    colors.forEach((color) => {
      if (!userPreference.colors.includes(color)) {
        userPreference.colors.push(color);
      }
    });
  }

  // Add flower types to array if not already present
  if (Array.isArray(flowerTypes)) {
    flowerTypes.forEach((flower) => {
      if (!userPreference.flowerType.includes(flower)) {
        userPreference.flowerType.push(flower);
      }
    });
  }

 
  

  await userPreference.save();
  return userPreference;
};

module.exports = { initializeUserPreference, updateUserPreference,checkUserPreferenceExists };
