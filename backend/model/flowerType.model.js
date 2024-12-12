const mongoose = require('mongoose');
const db = require('../config/db');

// Define a Color Schema
const flowerTypeSchema = new mongoose.Schema({
  flowerType: { type: String, required: true },
});

// Create the Color model
const flowerType = mongoose.model('flowerType', flowerTypeSchema, 'flowerTypes'); // Exact collection name

module.exports = flowerType;