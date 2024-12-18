const mongoose = require('mongoose');

// Define the schema for the user cart
const UserCartSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true, // Ensure username is unique for a cart
  },
  itemsId: {
    type: [String], // Array of item IDs
    default: [],
  },
}); // Automatically add createdAt and updatedAt fields

// Export the model
module.exports = mongoose.model('UserCart', UserCartSchema);
