const { getAllItems, createItem, getRecommendedItems } = require('../services/item.service');
const Item = require('../model/item.model');
const UserPreference = require('../model/userPreference.model');
const multer = require('multer');
const path = require('path');


const fetchItemsByTag = async (req, res) => {
  const { tag } = req.params; // Get the tag from the request URL (e.g., /items/tag/flowers)
  
  try {
    const items = await Item.find({ tags: tag }); // Look for items with the tag
    if (items.length === 0) { // If no items are found
      return res.status(404).json({ message: `No items found with tag: ${tag}` });
    }
    res.status(200).json(items); // Send the items as a JSON response
  } catch (error) {
    console.error(`Error fetching items by tag: ${error.message}`);
    res.status(500).json({ message: "Error fetching items", error }); // Handle errors
  }
};


// Controller to fetch all items
const fetchItems = async (req, res) => {
  try {
    const items = await getAllItems();
    res.status(200).json(items);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching items', error: error.message });
  }
};

const addItem = async (req, res) => {
  try {
    const itemData = {
      ...req.body,
      purchaseTimes: req.body.purchaseTimes || 0,
      careTips: req.body.careTips || "",
      wrapColor: req.body.wrapColor || [], // Default to an empty array if not provided
    };
    const newItem = await createItem(itemData);
    res.status(201).json(newItem);
  } catch (error) {
    res.status(500).json({ message: 'Error creating bouquet', error: error.message });
  }
};

// Set up `multer` for handling image uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});
const upload = multer({ storage: storage });



const createItemController = async (req, res) => {
  try {
    const imageURL = req.file ? `/uploads/${req.file.filename}` : null;
    const itemData = {
      ...req.body,
      imageURL,
      purchaseTimes: req.body.purchaseTimes || 0, // Default to 0 if not provided
      careTips: req.body.careTips || "", // Default to an empty string if not provided
      wrapColor: req.body.wrapColor || [], // Default to an empty array if not provided
    };

    const existingBouquet = await Item.findOne({ name: itemData.name });
    if (existingBouquet) {
      return res.status(409).json({ message: 'Bouquet already exists' });
    }

    const newItem = await createItem(itemData);
    res.status(201).json(newItem);
  } catch (error) {
    res.status(500).json({ message: 'Error creating bouquet', error: error.message });
  }
};


// Controller to fetch an item by its ID
const getItemById = async (req, res) => {
  try {
    const { id } = req.params;
    const bouquet = await Item.findById(id);

    if (!bouquet) {
      return res.status(404).json({ message: 'Bouquet not found' });
    }

    res.status(200).json(bouquet);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching bouquet', error: error.message });
  }
};
// Controller to fetch recommended items based on user preferences
const fetchRecommendedItems = async (req, res) => {
  try {
    const { username } = req.body; // Assuming the username is sent in the body

    const recommendedItems = await getRecommendedItems(username);

    if (recommendedItems.length === 0) {
      return res.status(404).json({ message: 'No recommended items found' });
    }

    res.status(200).json(recommendedItems);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching recommended items', error: error.message });
  }
};

// Middleware for image upload
const uploadImage = upload.single('image');
module.exports = { fetchItemsByTag,fetchItems, addItem, uploadImage, createItemController, getItemById, fetchRecommendedItems };
