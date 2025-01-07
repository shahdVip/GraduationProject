// routes/notificationRoutes.js
const express = require("express");
const notificationController = require("../controller/notification.controller");

const router = express.Router();

// Create a new notification (Admin or internal system use)
router.post("/create", notificationController.createNotification);

// Get all notifications for a specific user
router.get("/:username", notificationController.getNotifications);

// Mark a notification as read
router.patch(
  "/mark-read/:notificationId",
  notificationController.markNotificationRead
);

module.exports = router;
