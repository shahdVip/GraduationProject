const mongoose = require("mongoose");
const db = require("../config/db");

const notificationSchema = new mongoose.Schema(
  {
    username: {
      type: String,
      ref: "users", // Reference to the `users` collection
      required: true,
    },
    type: { type: String, required: true }, // e.g., 'NewOffer', 'OfferAccepted', 'OfferDenied'
    message: { type: String, required: true },
    isRead: { type: Boolean, default: false }, // Track if the user has read the notification
    createdAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

const NotificationModel = db.model("notifications", notificationSchema);
module.exports = NotificationModel;
