const mongoose = require('mongoose');
const db = require('../config/db');

// Define a Color Schema
const colorSchema = new mongoose.Schema({
  color: { type: String, required: true },
});

// Create the Color model
const color = mongoose.model('color', colorSchema,'colors');

module.exports = color;