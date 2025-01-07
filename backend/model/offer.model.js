const mongoose = require("mongoose");
const db = require("../config/db");
const { off } = require("./specialOrder.model");

const offerSchema = new mongoose.Schema({
  orderDetails: {
    type: Object, // Store the full specialOrder object
    required: true, // Ensure this field is always included
  },
  businessUsername: {
    type: String,
    required: true, // Make this field mandatory
  },
  price: {
    type: String, // Storing the price as a number for calculations
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now, // Automatically set the created date
  },
});

const OfferModel = db.model("offers", offerSchema);
module.exports = OfferModel;
