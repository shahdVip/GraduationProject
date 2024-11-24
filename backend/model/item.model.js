const mongoose = require('mongoose');
const db = require('../config/db');

const allowedTags = [
  'Get Well Soon',
  'Thank You',
  'Engagement',
  'Congratulations',
  'Graduation'
];

const itemSchema = new mongoose.Schema(
  {
    id: { type: String, required: false, unique: true },
    name: { type: String, required: true },
    flowerType: { type: [String], required: true },
    tags: {
      type: [String],
      required: true,
      validate: {
        validator: function (tags) {
          return tags.every(tag => allowedTags.includes(tag));
        },
        message: props => `${props.value} contains invalid tags. Allowed tags are: ${allowedTags.join(', ')}`,
      },
    },
    imageURL: { type: String, required: true },
    description: { type: String, required: true },
    business: { type: String, required: true },
    color: { type: [String], required: true },

    wrapColor: { type: [String], required: false , default: ['white'] }, // Add the wrapColor field

    price: { type: Number, required: true },
    purchaseTimes: { type: Number, default: 0 }, // New field with default value
    careTips: { type: String, default: '' }, // New field with default value
    
  },
  { autoIndex: false }
);

const ItemsModel = db.model('items', itemSchema);
module.exports = ItemsModel;