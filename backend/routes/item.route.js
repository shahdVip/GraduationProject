const express = require("express");
const multer = require("multer");
const ItemsModel = require("../model/item.model");
const mongoose = require("mongoose");

const {
  fetchItems,
  createItem,
  uploadImage,
  getItemById,
  fetchRecommendedItems,
  fetchItemsByTag,
  getTop4RatedItems,
  getTopRatedItems,
  fetchItemsByColor,
  getItemsByBusiness,
  updateItem,
} = require("../controller/item.controller");

const router = express.Router();

router.get("/items", fetchItems);

router.post("/addItem", uploadImage, createItem);
router.get("/items/:id", getItemById); // Route to fetch an item by ID
router.get("/items", fetchItems);
router.get("/items/tag/:tag", fetchItemsByTag);
router.get("/items/color/:color", fetchItemsByColor);
router.get("/top4-rated-items", getTop4RatedItems);
router.get("/top-rated-items", getTopRatedItems);

// Route to fetch items by business name
router.get("/business/:businessName", getItemsByBusiness);
//router.put("/update/:id", updateItem);
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/"); // The folder where images will be stored
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + "-" + file.originalname); // Unique filename
  },
});
const upload = multer({ storage });

router.put("/update/:id", upload.single("imageURL"), updateItem);
// Route to fetch recommended items
router.delete("/delete/:id", async (req, res) => {
  const { id } = req.params;

  // Validate ObjectId
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: "Invalid item ID" });
  }

  try {
    // Find and delete the item by its ObjectId
    const deletedItem = await ItemsModel.findByIdAndDelete(id);

    if (!deletedItem) {
      return res.status(404).json({ message: "Item not found" });
    }

    res.status(200).json({
      message: "Item deleted successfully",
      item: deletedItem, // Optional: return the deleted item
    });
  } catch (error) {
    console.error("Error deleting item:", error.message);
    res.status(500).json({
      message: "Error deleting item",
      error: error.message,
    });
  }
});

router.post("/recommendations", fetchRecommendedItems);

module.exports = router;
