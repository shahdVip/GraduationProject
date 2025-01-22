const offerService = require("../services/offer.service");
const SpecialOrderModel = require("../model/specialOrder.model");
const OfferModel = require("../model/offer.model");
const mongoose = require("mongoose");
const NotificationService = require("../services/notification.service"); // Import the notification service
const User = require("../model/user.model"); // Make sure to import your User model
const { sendFirebaseNotification } = require("../config/firebase");

// Create an offer
// Create a new offer
const createOffer = async (req, res) => {
  try {
    const { orderId, businessUsername, price } = req.body;

    // Call the service to create an offer
    const newOffer = await offerService.createOffer({
      orderId,
      businessUsername,
      price,
    });
    res.status(201).json(newOffer);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get all offers
const getAllOffers = async (req, res) => {
  try {
    const offers = await offerService.getAllOffers();
    res.status(200).json(offers);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Fetch offers by customerUsername
const getOffersByCustomerUsername = async (req, res) => {
  try {
    const { customerUsername } = req.body;

    // Call the service function
    const offers = await offerService.fetchOffersByCustomerUsername(
      customerUsername
    );

    // If no offers found, return a 404 response
    if (offers.length === 0) {
      return res
        .status(404)
        .json({ message: "No offers found for this customer." });
    }

    // Return the offers
    res.status(200).json({ success: true, offers });
  } catch (error) {
    // Handle errors
    if (error.message === "Customer username is required.") {
      return res.status(400).json({ success: false, message: error.message });
    }

    console.error("Error fetching offers:", error);
    res.status(500).json({ success: false, message: "Server error." });
  }
};

// Update order and delete associated offers
const updateOrderAndDeleteOffers = async (req, res) => {
  const { orderId, businessUsername, price } = req.body;

  try {
    const specialOrder = await SpecialOrderModel.findById(orderId);
    if (!specialOrder) throw new Error("Special order not found");

    // Step 1: Find the order by its ID
    const order = await SpecialOrderModel.findById(orderId);
    if (!order) {
      return res.status(404).json({ error: "Order not found" });
    }

    // Step 2: Update order details
    order.businessUsername = businessUsername;
    order.price = price;
    order.status = "Assigned";
    await order.save();

    // Step 3: Notify the accepted business
    await NotificationService.createNotification(
      specialOrder.customerUsername,
      "Order Assigned",
      `Your order "${specialOrder.orderName}" has been assigned to "${businessUsername}" !`
    );

    await NotificationService.createNotification(
      businessUsername,
      "Offer Accepted",
      `Your offer for "${specialOrder.customerUsername}" order "${specialOrder.orderName}" has been accepted!`
    );

    // Send a push notification to the customer
    // const customerDeviceToken = await getDeviceTokenByUsername(
    //   businessUsername
    // );

    // if (customerDeviceToken) {
    // Send the notification
    await sendFirebaseNotification(
      businessUsername,
      `Your offer for "${specialOrder.customerUsername}" order "${specialOrder.orderName}" has been accepted!`
    );
    console.log("Push notification sent to customer");
    // }

    // Step 4: Fetch all other offers for the same order
    const existingOffers = await OfferModel.find({
      "orderDetails._id": new mongoose.Types.ObjectId(orderId),
    });

    // Notify all businesses with rejected offers
    const otherBusinesses = existingOffers
      .filter((offer) => offer.businessUsername !== businessUsername)
      .map((offer) => offer.businessUsername);

    for (const otherBusiness of otherBusinesses) {
      await NotificationService.createNotification(
        otherBusiness,
        "Offer Rejected",
        `Another offer for "${specialOrder.customerUsername}" order "${specialOrder.orderName}" has been accepted.`
      );
    }

    // Step 3: Delete all offers associated with the orderId
    // Ensure that the orderId is cast to ObjectId for comparison
    const result = await OfferModel.deleteMany({
      "orderDetails._id": new mongoose.Types.ObjectId(orderId),
    });

    if (result.deletedCount === 0) {
      return res.status(404).json({ error: "No offers found for this order" });
    }

    return res.status(200).json({
      message: "Order updated and offers deleted successfully",
    });
  } catch (error) {
    console.error("Error updating order:", error);
    return res
      .status(500)
      .json({ error: "Failed to update order or delete offers" });
  }
};
const getDeviceTokenByUsername = async (username) => {
  // Assuming you have a collection to store device tokens
  const user = await User.findOne({ username });
  return user?.deviceToken;
};

const deleteOfferById = async (req, res) => {
  const { offerId } = req.params; // Get offerId from the request parameters

  try {
    // Call the service to delete the offer by its ID
    const result = await offerService.deleteOfferById(offerId);

    if (!result) {
      return res.status(404).json({ error: "Offer not found" });
    }

    return res.status(200).json({ message: "Offer deleted successfully" });
  } catch (error) {
    console.error("Error deleting offer:", error);
    return res.status(500).json({ error: "Failed to delete offer" });
  }
};

// Controller method to fetch offers by businessUsername
const getOffersByBusiness = async (req, res) => {
  const { businessUsername } = req.body; // Get the businessUsername from the request body

  // Validate the input (businessUsername)
  if (!businessUsername) {
    return res.status(400).json({
      status: "fail",
      message: "Business username is required",
    });
  }

  try {
    // Call the service to fetch offers based on businessUsername
    const offers = await offerService.getOffersByBusiness(businessUsername);

    // If no offers are found
    if (offers.length === 0) {
      return res.status(404).json({
        status: "fail",
        message: "No offers found for this business username",
      });
    }

    // Send the fetched offers as the response
    res.status(200).json({
      status: "success",
      data: offers,
    });
  } catch (error) {
    // Handle any errors that occur during the fetching process
    console.error("Error fetching offers:", error);
    res.status(500).json({
      status: "error",
      message: "An error occurred while fetching the offers",
    });
  }
};

module.exports = {
  createOffer,
  getAllOffers,
  getOffersByCustomerUsername,
  updateOrderAndDeleteOffers,
  deleteOfferById,
  getOffersByBusiness,
};
