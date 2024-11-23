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

const createItem = async (itemData) => {
  try {
    const newItem = new Item(itemData);
    await newItem.save();
    return newItem;
  } catch (error) {
    throw new Error('Error creating item: ' + error.message);
  }
};


// Function to fetch items based on user preferences
const getRecommendedItems = async (username) => {
  try {
    const userPreference = await UserPreference.findOne({ username });
    if (!userPreference) {
      throw new Error('User preferences not found');
    }

    const { flowerType, colors, tags } = userPreference;

    const items = await Item.find();

    const scoredItems = items.map((item) => {
      let score = 0;

      // Increase score for matching flowerType
      if (flowerType.some(type => item.flowerType.includes(type))) score += 1;

      // Increase score for matching color
      if (colors.some(color => item.color.includes(color))) score += 1;

      // Increase score for matching tags
      const matchingTags = item.tags.filter(tag => tags.includes(tag));
      score += matchingTags.length;

      return { item, score };
    });

    scoredItems.sort((a, b) => b.score - a.score);

    return scoredItems.filter(({ score }) => score > 0).map(({ item }) => item);
  } catch (error) {
    throw new Error('Error fetching recommended items: ' + error.message);
  }
};

module.exports = { getAllItems, createItem, getRecommendedItems };
