const SpecialOrderModel = require("../model/specialOrder.model");
const {
  updateLatestSpecialOrder,
} = require("../services/specialOrder.service");

// This will save bouquet details to the database
const saveBouquetCustomization = async (req, res) => {
  try {
    const { selectedAssets, flowerCount } = req.body; // Receive bouquet details from the frontend

    // Save bouquet customization
    const bouquet = new SpecialOrderModel({
      selectedAssets, // Array of selected assets with colors
      flowerCount, // Flower count if relevant
    });

    await bouquet.save();
    res.status(200).json({ message: "Special order saved successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error saving Special order" });
  }
};

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

module.exports = { saveBouquetCustomization, updateSpecialOrder };
