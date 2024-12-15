const mongoose = require('mongoose');
const db = require('../config/db');

const orderSchema = new mongoose.Schema(
  {
    id: { type: String, required: false, unique: true },
    customerUsername: { type: String, required: true },
    bouquetsId: { type: [String], required: true },
    businessUsername: {type: [String],required: true},
    totalPrice: { type: Number, required: true },
    time: { type: String, required: true }, // New field with default value
    status: { type: [String], required: true } // New field with default value
    
  },
);

const orderModel = db.model('orders', orderSchema);
module.exports = orderModel;