const mongoose = require('mongoose');
const db = require('../config/db');


const userPreferenceSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  colors: { type: [String], default: [] },
  flowerType: { type: [String], default: [] },
  tags: { type: [String], default: [] },
});

const UserPreferenceModel = db.model('userPreference', userPreferenceSchema);
module.exports = UserPreferenceModel;
