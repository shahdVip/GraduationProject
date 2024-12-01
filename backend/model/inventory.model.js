// models/inventory.model.js

const mongoose = require('mongoose');
const db = require('../config/db');

const FlowerSchema = new mongoose.Schema({
  flowerType: { type: String, required: true },
  quantity: { type: Number, required: true },
  color: { type: String, required: true },
  careTips: { type: String },
  image: { type: String }, // URL to the flower's image
});

const InventorySchema = new mongoose.Schema({
  username: { type: String, required: true }, // Business username
  flowers: [FlowerSchema], // Array of flowers for the business
});
const InventoryModel = db.model('inventory', InventorySchema);

module.exports = InventoryModel;