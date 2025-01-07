// controllers/notificationController.js
const notificationService = require("../services/notification.service");

const createNotification = async (req, res) => {
  const { username, type, message } = req.body;

  try {
    const notification = await notificationService.createNotification(
      username,
      type,
      message
    );
    if (!notification) {
      return res
        .status(404)
        .json({ status: "error", message: "User not found for notification" });
    }
    res.status(201).json({ status: "success", data: notification });
  } catch (error) {
    res.status(500).json({ status: "error", message: error.message });
  }
};
const getNotifications = async (req, res) => {
  const { username } = req.params;

  try {
    // Fetch notifications for the provided username
    const notifications = await notificationService.getNotificationsByUsername(
      username
    );

    if (!notifications || notifications.length === 0) {
      return res
        .status(404)
        .json({ message: "No notifications found for this username" });
    }

    return res.status(200).json(notifications);
  } catch (error) {
    console.error("Error fetching notifications:", error);
    return res.status(500).json({ error: "Failed to fetch notifications" });
  }
};

const markNotificationRead = async (req, res) => {
  const { notificationId } = req.params;

  try {
    const notification = await notificationService.markNotificationAsRead(
      notificationId
    );
    res.status(200).json({ status: "success", data: notification });
  } catch (error) {
    res.status(500).json({ status: "error", message: error.message });
  }
};

module.exports = {
  createNotification,
  getNotifications,
  markNotificationRead,
};
