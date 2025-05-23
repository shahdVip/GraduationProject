const mongoose = require('mongoose');
const db = require('../config/db');

const orderSchema = new mongoose.Schema({
  customerUsername: { type: String, required: true },
  bouquetsId: { type: [String], required: true },
  businessUsername: { type: [String], required: true },
  totalPrice: { type: Number, required: true },
  time: { type: String, default: () => new Date().toISOString() }, // Automatically set current time
  status: { type: [String], required: true }
});

const orderModel = db.model('orders', orderSchema);
module.exports = orderModel;