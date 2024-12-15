const mongoose = require("mongoose");
const db = require("../config/db");

const userCartSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  items: [
    {
      itemName: { type: String, required: true }, // Changed from itemId to itemName
      quantity: { type: Number, required: true },
    },
  ],
});

const UserCartModel = db.model("userCart", userCartSchema);
module.exports = UserCartModel;
