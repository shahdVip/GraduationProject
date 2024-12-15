const mongoose = require("mongoose");
const db = require("../config/db");

const bouquetSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" }, // Optional: if you link the bouquet to a user
  selectedAssets: [
    {
      categoryName: { type: String, required: true },
      asset: { type: mongoose.Schema.Types.ObjectId, ref: "Asset" }, // Reference to the chosen asset
      color: { type: String }, // Color chosen for the asset (if applicable)
    },
  ],
  flowerCount: { type: Number, default: 1 }, // Flower count if relevant for the bouquet
  createdAt: { type: Date, default: Date.now }, // Add createdAt field
  customerUsername: { type: String }, // Add customerUsername field
});

const SpecialOrderModel = db.model("specialOrder", bouquetSchema);
module.exports = SpecialOrderModel;
