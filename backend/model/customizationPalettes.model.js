const mongoose = require("mongoose");
const db = require("../config/db");

const customizationPalettesSchema = new mongoose.Schema({
  name: {
    type: String,
  },
  colors: {
    type: mongoose.Schema.Types.Mixed, // For storing JSON objects
  },
  created: {
    type: Date,
    default: Date.now,
  },
  updated: {
    type: Date,
    default: Date.now,
  },
});
const customizationPalettesModel = db.model(
  "CustomizationPalette",
  customizationPalettesSchema
);

module.exports = customizationPalettesModel;
