const mongoose = require("mongoose");
const db = require("../config/db");

const bouquetSchema = new mongoose.Schema({
  selectedAssets: [
    {
      asset: String, // Store the asset name as a string
      categoryName: String,
      color: String,
    },
  ],
  flowerCount: { type: Number, default: 1 }, // Flower count if relevant for the bouquet
  createdAt: { type: Date, default: Date.now }, // Add createdAt field
  customerUsername: { type: String }, // Add customerUsername field
  fileName: { type: String }, // Add filePath field to store the file path
});

const SpecialOrderModel = db.model("specialOrder", bouquetSchema);
module.exports = SpecialOrderModel;
