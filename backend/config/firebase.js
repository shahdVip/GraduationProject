const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
const serviceAccount = require("../../grad_roze/android/app/roze-657d4-firebase-adminsdk-zc9fs-2a4479a0b6.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Function to send push notifications
const sendPushNotification = async (deviceToken, title, message) => {
  const payload = {
    notification: {
      title: title,
      body: message,
    },
    token: deviceToken,
  };

  try {
    await admin.messaging().send(payload);
    console.log("Push notification sent ", payload);
  } catch (error) {
    console.error("Error sending push notification:", error);
  }
};

module.exports = { sendPushNotification };
