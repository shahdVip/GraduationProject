const mongoose = require("mongoose");
const db = require("../config/db");

const customizationAssetsSchema = new mongoose.Schema({
  group: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "CustomizationGroup",
  },
  name: {
    type: String,
  },
  thumbnail: {
    type: String,
  },
  url: {
    type: String,
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

const customizationAssetsModel = db.model(
  "CustomizationAsset",
  customizationAssetsSchema
);

module.exports = customizationAssetsModel;
