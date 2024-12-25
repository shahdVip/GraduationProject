const mongoose = require("mongoose");
const db = require("../config/db");

const bouquetSchema = new mongoose.Schema({
  selectedAssets: [
    {
      asset: String, // Store the asset name as a string
      categoryName: String,
      color: String,
      flowerCount: Number, // Flower count if relevant for the bouquet
    },
  ],
  orderName: { type: String }, // Add orderName field to store the name of the bouquet
  flowerCount: { type: Number, default: 1 }, // Flower count if relevant for the bouquet
  createdAt: { type: Date, default: Date.now }, // Add createdAt field
  customerUsername: { type: String }, // Add customerUsername field
  businessUsername: { type: String, default: "Unassigned" }, // Add businessUsername field
  fileName: { type: String }, // Add filePath field to store the file path
  price: { type: String }, // Add price field to store the price of the bouquet
  status: {
    type: String, // Define the type explicitly
    enum: ["Assigned", "New"], // Define valid enum values
    default: "New", // Set the default value
  }, // Add status field to store the status of the bouquet
});
const SpecialOrderModel = db.model("specialOrder", bouquetSchema);
module.exports = SpecialOrderModel;

// const bouquetSchema = new mongoose.Schema({
//   selectedAssets: [
//     {
//       asset: String, // Store the asset name as a string
//       categoryName: String,
//       color: String,
//       flowerCount: Number, // Flower count if relevant for the bouquet
//     },
//   ],
//   orderName: { type: String }, // Add orderName field to store the name of the bouquet
//   flowerCount: { type: Number, default: 1 }, // Flower count if relevant for the bouquet
//   createdAt: { type: Date, default: Date.now }, // Add createdAt field
//   customerUsername: { type: String }, // Add customerUsername field
//   businessUsername: { type: String, default: "Unassigned" }, // Add businessUsername field
//   fileName: { type: String }, // Add filePath field to store the file path
//   price: { type: String }, // Add price field to store the price of the bouquet
//   status: {
//     type: String, // Define the type explicitly
//     enum: ["Pending", "AcceptedByCustomer", "RejectedByCustomer", "New"], // Define valid enum values
//     default: "New", // Set the default value
//   }, // Add status field to store the status of the bouquet
// });
