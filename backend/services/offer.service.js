const OfferModel = require("../model/offer.model");
const SpecialOrderModel = require("../model/specialOrder.model");
const NotificationService = require("../services/notification.service"); // Import the notification service
const mongoose = require("mongoose");
const User = require("../model/user.model"); // Make sure to import your User model
const admin = require("../config/firebase");
const { sendPushNotification } = require("../config/firebase");

// Create an offer

// Create a new offer with the full specialOrder object
const createOffer = async (offerData) => {
  const { orderId, businessUsername, price } = offerData;

  // Fetch the full specialOrder object based on orderId
  const specialOrder = await SpecialOrderModel.findById(orderId);
  if (!specialOrder) throw new Error("Special order not found");

  // Create the offer with the full specialOrder object in orderDetails
  const newOffer = new OfferModel({
    orderDetails: specialOrder, // Save the full specialOrder object
    businessUsername,
    price,
  });
  await newOffer.save();

  // Notify the customer who created the special order
  const customerUsername = specialOrder.customerUsername;
  await NotificationService.createNotification(
    customerUsername,
    "New Offer",
    `A new offer has been made for your order: ${specialOrder.orderName}`
  );

  // Send a push notification to the customer
  const customerDeviceToken = await getDeviceTokenByUsername(customerUsername);

  if (customerDeviceToken) {
    // Send the notification
    await sendPushNotification(
      customerDeviceToken,
      customerUsername,
      `A new offer has been made for your order: ${specialOrder.orderName}`
    );
    console.log("Push notification sent to customer");
  }
  // Fetch all offers for the same order
  const existingOffers = await OfferModel.find({
    "orderDetails._id": new mongoose.Types.ObjectId(orderId),
  });
  console.log("Existing offers:", existingOffers);
  // Extract business usernames that made offers for the same order
  const otherBusinesses = existingOffers
    .map((offer) => offer.businessUsername)
    .filter((username) => username !== businessUsername); // Exclude the current business

  // Send notifications to other businesses
  const notificationPromises = otherBusinesses.map((username) =>
    NotificationService.createNotification(
      username,
      "New Offer On Same Order",
      `A new offer has been made for the order you also offered on: ${specialOrder.orderName}`
    )
  );

  // Ensure all notifications are sent
  await Promise.all(notificationPromises);

  return newOffer;
};
// Function to fetch the device token based on username (you can store and retrieve this token from your database)
const getDeviceTokenByUsername = async (username) => {
  // Assuming you have a collection to store device tokens
  const user = await User.findOne({ username });
  return user?.deviceToken;
};

// Get all offers
const getAllOffers = async () => {
  return await OfferModel.find();
};

// Fetch offers by customerUsername
const fetchOffersByCustomerUsername = async (customerUsername) => {
  if (!customerUsername) {
    throw new Error("Customer username is required.");
  }

  // Query to find offers where orderDetails contains the customerUsername
  const offers = await OfferModel.find({
    "orderDetails.customerUsername": customerUsername,
  });

  return offers;
};

const deleteOfferById = async (offerId) => {
  try {
    // Find the offer by its ID and delete it
    const result = await OfferModel.findByIdAndDelete(offerId);

    // If no offer is found, return null
    if (!result) {
      return null;
    }

    return result; // Return the deleted offer document
  } catch (error) {
    console.error("Error deleting offer in service:", error);
    throw new Error("Failed to delete offer");
  }
};

// Service method to fetch offers by businessUsername
const getOffersByBusiness = async (businessUsername) => {
  // Query the Offer collection to find all offers with the specified businessUsername
  return await OfferModel.find({ businessUsername });
};

module.exports = {
  createOffer,
  getAllOffers,
  fetchOffersByCustomerUsername,
  deleteOfferById,
  getOffersByBusiness,
};
