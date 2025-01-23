// routes/notificationRoutes.js
const express = require("express");
const notificationController = require("../controller/notification.controller");
const { sendFirebaseNotification } = require("../config/firebase");

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

// Endpoint to send push notifications
router.post("/send-message", async (req, res) => {
  const { deviceToken, title, message } = req.body;

  try {
    await sendFirebaseNotification(title, message);
    res.status(200).send({ message: "Push notification sent successfully" });
  } catch (error) {
    res.status(500).send({ error: "Failed to send push notification" });
  }
});

module.exports = router;
