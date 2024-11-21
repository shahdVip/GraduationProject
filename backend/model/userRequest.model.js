// models/userRequest.model.js
const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const userRequestSchema = new Schema({
  email: {
    type: String,
    required: true,
    unique: true,
  },
  username: {
    type: String,
    required: true,
  },
  role: {
    type: String,
    enum: ['Customer', 'Business'],
    required: true,
  },
  profilePhoto: {
    type: String,
    required: false,
  },
  status:{
    type: String,
    required: false,

  },
  createdAt:{
    type : Date,
    required: false
  }
});

const UserRequestModel = db.model('UserRequest', userRequestSchema);


module.exports = UserRequestModel;