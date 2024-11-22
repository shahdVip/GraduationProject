const mongoose = require('mongoose');
const db = require('../config/db');

const itemSchema = new mongoose.Schema({
  id: {type: String, required: true },
  name: { type: String, required: true },
  flowerType: { type: String, required: true },
  tags: { type: [String], required: true },
  imageURL: { type: String, required: true },
  description: { type: String, required: true },
  business: { type: String, required: true },
  color: { type: String, required: true },
  price: { type: Number, required: true }, // Added the price field
}, { autoIndex: false }); // You can set `autoIndex: false` to prevent Mongoose from automatically creating indexes

const ItemsModel = db.model('items', itemSchema);
module.exports = ItemsModel;
