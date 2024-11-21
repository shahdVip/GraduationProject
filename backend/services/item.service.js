const Item = require('../model/item.model');
const UserPreference = require('../model/userPreference.model');

// Service to fetch all items
const getAllItems = async () => {
  try {
    const items = await Item.find();
    return items;
  } catch (error) {
    throw new Error('Error fetching items: ' + error.message);
  }
};

// Service to handle item creation
const createItem = async (itemData) => {
  try {
    const newItem = new Item(itemData); // itemData should include the price field
    await newItem.save();
    return newItem;
  } catch (error) {
    throw new Error('Error creating item: ' + error.message);
  }
};




// Function to fetch items based on user preferences
const getRecommendedItems = async (username) => {
  try {
    // Fetch user preferences
    const userPreference = await UserPreference.findOne({ username });
    if (!userPreference) {
      throw new Error('User preferences not found');
    }

    // Extract preferences
    const { flowerType, colors, tags } = userPreference;

    // Fetch all items
    const items = await Item.find();

    // Score items based on preferences
    const scoredItems = items.map((item) => {
      let score = 0;

      // Increase score for matching flowerType
      if (flowerType.includes(item.flowerType)) score += 1;

      // Increase score for matching color
      if (colors.includes(item.color)) score += 1;

      // Increase score for matching tags
      const matchingTags = item.tags.filter(tag => tags.includes(tag));
      score += matchingTags.length; // Increase score by the number of matching tags

      return { item, score };
    });

    // Sort items by score in descending order
    scoredItems.sort((a, b) => b.score - a.score);

    // Return items with a positive score
    return scoredItems.filter(({ score }) => score > 0).map(({ item }) => item);
  } catch (error) {
    throw new Error('Error fetching recommended items: ' + error.message);
  }
};




module.exports = { getAllItems, createItem ,getRecommendedItems};
