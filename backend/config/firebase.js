const admin = require("firebase-admin");

// Set the path to your Firebase service account key file
const serviceAccountPath =
  "C:\\Users\\user\\GraduationProject-2\\backend\\config\\roze-657d4-firebase-adminsdk-zc9fs-2a4479a0b6.json";

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(require(serviceAccountPath)),
    databaseURL: "https://roze-657d4-default-rtdb.firebaseio.com",
  });
}

// Function to send push notifications
const sendFirebaseNotification = async (title, body) => {
  try {
    const message = {
      notification: { title, body },
      token: fcmToken,
    };
    const response = await admin.messaging().send(message);
    console.log("Notification sent successfully:", response);
  } catch (error) {
    console.error("Error sending notification:", error.code, error.message);
  }
};

// Example usage
const fcmToken =
  "c00yJFUcQACgGMkE-vMtYc:APA91bFW2I4qaoz68VsdzbPPyu7t-SKqMEbK3zXrirI-JyZl7ZZ2B9uox4NqaHndIjfjopvFIdbzZ7g_Fqu9v9_3ogzEYH-qVB2HBMwITPLE8_pEFxTxhj0";
module.exports = { sendFirebaseNotification };
