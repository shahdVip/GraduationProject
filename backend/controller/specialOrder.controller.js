const SpecialOrderModel = require("../model/specialOrder.model");
const {
  updateLatestSpecialOrder,
} = require("../services/specialOrder.service");
const path = require("path");
const fs = require("fs");
// Multer setup for file uploads
const multer = require("multer");
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = path.join(
      __dirname,
      "..",
      "..",
      "grad_roze",
      "assets",
      "specialOrders"
    );
    // Ensure directory exists
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now();
    cb(null, `bouquet_${uniqueSuffix}.glb`); // Name the file dynamically
  },
});

const upload = multer({ storage });

// Save special order with file upload
const saveBouquetCustomization = async (req, res) => {
  try {
    const { selectedAssets, flowerCount } = req.body;

    // Extract the uploaded file name
    const fileName = req.file ? req.file.filename : null;

    // Save bouquet customization with file details
    const bouquet = new SpecialOrderModel({
      selectedAssets: JSON.parse(selectedAssets), // Parse the selectedAssets array from string
      flowerCount,

      fileName, // Store the uploaded file name
    });

    // Save to database
    await bouquet.save();

    // Respond with success message
    res
      .status(200)
      .json({ message: "Special order saved successfully", bouquet });
  } catch (error) {
    console.error("Error saving special order:", error);
    res.status(500).json({ message: "Error saving Special order" });
  }
};

// // This will save bouquet details to the database
// const saveBouquetCustomization = async (req, res) => {
//   try {
//     const { selectedAssets, flowerCount, fileName } = req.body; // Receive bouquet details and file path from the frontend

//     // Save bouquet customization with file path
//     const bouquet = new SpecialOrderModel({
//       selectedAssets, // Array of selected assets with colors
//       flowerCount, // Flower count if relevant
//       fileName, // Save the file path of the 3D model or asset
//     });

//     // Save the bouquet data to the database
//     await bouquet.save();

//     // Respond with a success message
//     res.status(200).json({ message: "Special order saved successfully" });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: "Error saving Special order" });
//   }
// };

const updateSpecialOrder = async (req, res) => {
  try {
    const { username } = req.body; // Get username from the request body

    // Delegate the update logic to the service
    const updatedOrder = await updateLatestSpecialOrder(username);

    if (!updatedOrder) {
      return res.status(404).json({ message: "No special orders found" });
    }

    return res.status(200).json(updatedOrder); // Return the updated order
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Internal server error" });
  }
};

module.exports = { saveBouquetCustomization, updateSpecialOrder, upload };
