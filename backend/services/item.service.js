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
    const newItem = new Item(itemData); // wrapColor is automatically handled here
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

    const { flowerType, colors } = userPreference;

    const items = await Item.find();

    const scoredItems = items.map((item) => {
      let score = 0;
// Count the number of matching flowerTypes
const matchingFlowerTypes = flowerType.filter(type => item.flowerType.includes(type));
score += matchingFlowerTypes.length;
if (matchingFlowerTypes.length > 0) {
  console.log(`FlowerType Match: Item "${item.name}" matches ${matchingFlowerTypes.length} types: ${matchingFlowerTypes.join(", ")}`);
}

// Count the number of matching colors
const matchingColors = colors.filter(color => item.color.includes(color));
score += matchingColors.length;


      return { item, score };
    });
    const filteredItems = scoredItems.filter(({ score }) => score > 1);
    filteredItems.sort((a, b) => b.score - a.score);

    return filteredItems
  } catch (error) {
    throw new Error('Error fetching recommended items: ' + error.message);
  }
};
 
module.exports = { getAllItems, createItem, getRecommendedItems };