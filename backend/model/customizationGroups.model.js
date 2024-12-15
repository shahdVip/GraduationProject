const mongoose = require("mongoose");
const db = require("../config/db");

const customizationGroupsSchema = new mongoose.Schema({
  name: {
    type: String,
  },
  position: {
    type: Number,
  },
  colorPalette: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "CustomizationPalette",
  },
  removable: {
    type: Boolean,
    default: false,
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

const customizationGroupsModel = db.model(
  "CustomizationGroup",
  customizationGroupsSchema
);

module.exports = customizationGroupsModel;
