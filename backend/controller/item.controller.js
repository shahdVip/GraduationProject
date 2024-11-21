const { getAllItems, createItem ,getRecommendedItems} = require('../services/item.service');
const Item = require('../model/item.model');
const multer = require('multer');
const path = require('path');



const fetchRecommendedItems = async (req, res) => {
  try {
    const { username } = req.body; // Get the username from the request body
    const recommendedItems = await getRecommendedItems(username);
    res.status(200).json(recommendedItems);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching recommended items', error: error.message });
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

// Controller to add an item
const addItem = async (req, res) => {
  try {
    const itemData = req.body; // Make sure the request body includes all necessary fields, including `price`
    const newItem = await createItem(itemData);
    res.status(201).json(newItem);
  } catch (error) {
    res.status(500).json({ message: 'Error creating item', error: error.message });
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

// Controller to handle item creation with an image
const createItemController = async (req, res) => {
  try {
    const imageURL = req.file ? `/uploads/${req.file.filename}` : null; // Construct image URL if uploaded
    const itemData = {
      ...req.body,
      imageURL, // Include the image URL in itemData
    };

    const newItem = await createItem(itemData);
    res.status(201).json(newItem);
  } catch (error) {
    res.status(500).json({ message: 'Error creating item', error: error.message });
  }
};

// Controller to fetch an item by its ID
const getItemById = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await Item.findById(id);

    if (!item) {
      return res.status(404).json({ message: 'Item not found' });
    }

    res.status(200).json(item);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching item', error: error.message });
  }
};

// Middleware for image upload
const uploadImage = upload.single('image');

module.exports = { fetchItems, addItem, uploadImage, createItemController, getItemById ,fetchRecommendedItems};
