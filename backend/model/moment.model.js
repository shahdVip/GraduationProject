const mongoose = require("mongoose");
const db = require('../config/db');

const { Schema } = mongoose;

const momentSchema = new Schema({
  imageUrl: { type: String, required: true },
  text: { type: String, required: true },
});
const MomentModel =db.model("Moment", momentSchema);
module.exports = MomentModel;
