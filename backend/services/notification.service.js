// services/notificationService.js
const NotificationModel = require("../model/notification.model");
const UserModel = require("../model/user.model");

const createNotification = async (username, type, message) => {
  const user = await UserModel.findOne({ username });
  if (!user) {
    console.warn(`User ${username} not found. Notification skipped.`);
    return null;
  }

  const notification = new NotificationModel({
    username: user.username,
    type,
    message,
  });

  await notification.save();
  return notification;
};

const getNotificationsByUsername = async (username) => {
  // Fetch notifications sorted by creation date (most recent first)
  return await NotificationModel.find({ username }).sort({ createdAt: -1 });
};

const markNotificationAsRead = async (notificationId) => {
  const notification = await NotificationModel.findById(notificationId);
  if (!notification) {
    throw new Error("Notification not found");
  }

  notification.isRead = true;
  await notification.save();
  return notification;
};

module.exports = {
  createNotification,
  getNotificationsByUsername,
  markNotificationAsRead,
};
