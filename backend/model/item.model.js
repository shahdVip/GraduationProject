const mongoose = require('mongoose');
const db = require('../config/db');

const itemSchema = new mongoose.Schema(
  {
    id: { type: String, required: false, unique: true },
    name: { type: String, required: true ,unique: true},
    flowerType: { type: [String], required: true },
    tags: {
      type: [String],
      required: true,
    },
    imageURL: { type: String,  },
    description: { type: String, required: true },
    business: { type: String, required: true },
    color: { type: [String], required: true },
    wrapColor: { type: [String], required: false , default: ['white'] }, // Add the wrapColor field
    price: { type: Number, required: true },
    rating: { type: Number, default: 0 }, // New field with default value
    careTips: { type: String, default: '' }, // New field with default value
    purchaseTimes: { type: Number, default: 0 },
    
  },
  { autoIndex: false }
);

const ItemsModel = db.model('items', itemSchema);
module.exports = ItemsModel;