const { getAllItems, getRecommendedItems } = require("../services/item.service");
const Item = require("../model/item.model");
const UserPreference = require("../model/userPreference.model");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const mongoose = require("mongoose");

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
const fetchItemsByColor = async (req, res) => {
  const { color } = req.params; // Get the tag from the request URL (e.g., /items/tag/flowers)
  
  try {
    const items = await Item.find({ color: color }); // Look for items with the tag
    if (items.length === 0) { // If no items are found
      return res.status(404).json({ message: `No items found with color: ${color}` });
    }
    res.status(200).json(items); // Send the items as a JSON response
  } catch (error) {
    console.error(`Error fetching items by color: ${error.message}`);
    res.status(500).json({ message: "Error fetching items", error }); // Handle errors
  }
};

// Controller function to fetch items by business name
const getItemsByBusiness = async (req, res) => {
  const { businessName } = req.params; // Extract businessName from route parameters

  try {
    // Fetch items matching the provided business name
    const items = await Item.find({ business: businessName });

    if (!items || items.length === 0) {
      return res.status(404).json({ message: "No items found for the given business name." });
    }

    // Return the fetched items
    res.status(200).json(items);
  } catch (error) {
    // Handle errors
    console.error("Error fetching items by business:", error);
    res.status(500).json({ message: "An error occurred while fetching items.", error: error.message });
  }
};

const updateItem =async (req, res) => {
  const { id } = req.params;

  // Validate ObjectId
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: "Invalid item ID" });
  }

  const {
    name,
    color,
    flowerType,
    tags,
    description,
    careTips,
    price,
    imageURL,
  } = req.body;

  // Skip imageURL if it's not provided or empty
  const updatedFields = {
    ...(name && { name }),
    ...(color && { color }),
    ...(flowerType && { flowerType }),
    ...(tags && { tags }),
    ...(description && { description }),
    ...(careTips && { careTips }),
    ...(price && { price }),
  };

  if (req.file) {
    // Handle uploaded image if a new one is provided
    updatedFields.imageURL = `/uploads/${req.file.filename}`;
  } else if (imageURL) {
    // Use existing imageURL if provided
    updatedFields.imageURL = imageURL;
  }

  try {
    const updatedItem = await Item.findByIdAndUpdate(
      id,
      { $set: updatedFields },
      { new: true, runValidators: true }
    );

    if (!updatedItem) {
      return res.status(404).json({ message: "Item not found" });
    }

    res.status(200).json({ message: "Item updated successfully", updatedItem });
  } catch (error) {
    console.error("Error updating item:", error);
    res.status(500).json({ message: "Failed to update item", error: error.message });
  }
};
// Controller to fetch all items
const fetchItems = async (req, res) => {
  try {
    const items = await getAllItems();
    res.status(200).json(items);
  } catch (error) {
    res.status(500).json({ message: "Error fetching items", error: error.message });
  }
};

// Set up `multer` for handling image uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, "../uploads")); // Directory where files are stored
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}-${file.originalname}`); // Unique filename
  },
});
const upload = multer({ storage: storage });



// Helper function to delete uploaded files
const deleteFile = (filePath) => {
  fs.unlink(filePath, (err) => {
    if (err) {
      console.error("Error deleting file:", err);
    }
  });
};

// Create item controller
const createItem = async (req, res) => {
  try {
    let imageURL = null;

    if (req.file) {
      imageURL = `/uploads/${req.file.filename}`;
    } else if (req.body.useDefaultImage === "true") {
      imageURL = "/frontend-assets/images/defaults/bouquet.png";
    }
    const itemData = {
      ...req.body,
      tags: req.body.tags ? req.body.tags.split(",") : [],
      color: req.body.color ? req.body.color.split(",") : [],
      flowerType: req.body.flowerType ? req.body.flowerType.split(",") : [],
      imageURL,
      purchaseTimes: req.body.purchaseTimes || 0,
      careTips: req.body.careTips || "",
      wrapColor: req.body.wrapColor || ["white"],
    };

    // Check if item already exists
    const existingItem = await Item.findOne({ name: itemData.name });
    if (existingItem) {
      if (req.file) {
        const filePath = path.join(__dirname, "..", "uploads", req.file.filename);
        fs.unlink(filePath, (err) => {
          if (err) {
            console.error("Error deleting file:", err);
          }
        });
      }
      return res.status(409).json({ message: "Bouquet already exists" });
    }

    // Save new item
    const newItem = await Item.create(itemData);
    res.status(201).json(newItem);
  } catch (error) {
    if (req.file) {
      const filePath = path.join(__dirname,  "..", "uploads", req.file.filename);
      deleteFile(filePath);
    }
    console.error("Error creating item:", error);
    res.status(500).json({ message: "Error creating bouquet", error: error.message });
  }
};

// Controller to fetch an item by its ID
const getItemById = async (req, res) => {
  try {
    const { id } = req.params;
    const bouquet = await Item.findById(id);

    if (!bouquet) {
      return res.status(404).json({ message: "Bouquet not found" });
    }

    res.status(200).json(bouquet);
  } catch (error) {
    res.status(500).json({ message: "Error fetching bouquet", error: error.message });
  }
};
// Controller to fetch recommended items based on user preferences
const fetchRecommendedItems = async (req, res) => {
  try {
    const { username } = req.body; // Assuming the username is sent in the body

    const recommendedItems = await getRecommendedItems(username);

    if (recommendedItems.length === 0) {
      return res.status(404).json({ message: "No recommended items found" });
    }

    res.status(200).json(recommendedItems);
  } catch (error) {
    res.status(500).json({ message: "Error fetching recommended items", error: error.message });
  }
};
const getTop4RatedItems = async (req, res) => {
  try {
    const topRatedItems = await Item.find().sort({ rating: -1 }).limit(4);
    res.status(200).json(topRatedItems);
  } catch (err) {
    res.status(500).json({ message: "Server error: Unable to fetch items.", error: err });
  }
};
const getTopRatedItems = async (req, res) => {
  try {
    const topRatedItems = await Item.find().sort({ rating: -1 }).limit(10);
    res.status(200).json(topRatedItems);
  } catch (err) {
    res.status(500).json({ message: "Server error: Unable to fetch items.", error: err });
  }
};

// Middleware for image upload
const uploadImage = upload.single("image");
module.exports = { updateItem,getItemsByBusiness,fetchItemsByColor,getTopRatedItems, getTop4RatedItems,fetchItemsByTag,fetchItems, createItem, uploadImage, getItemById, fetchRecommendedItems };
