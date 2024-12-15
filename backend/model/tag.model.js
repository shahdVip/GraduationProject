const mongoose = require('mongoose');
const db = require('../config/db');

// Define a Tag Schema
const tagSchema = new mongoose.Schema({
  tag: { type: String, required: true },
});

// Create the Tag model
const tag = mongoose.model('tag', tagSchema,'tags');

module.exports = tag;