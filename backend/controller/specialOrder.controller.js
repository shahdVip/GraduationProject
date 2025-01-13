const mongoose = require("mongoose");
const UserModel = require("../model/user.model"); // Make sure to import your User model
const NotificationService = require("../services/notification.service"); // Import the notification service
const { sendPushNotification } = require("../config/firebase");

const SpecialOrderModel = require("../model/specialOrder.model");
const {
  updateLatestSpecialOrder,
  getSpecialOrdersService,
  fetchPendingOrdersByCustomer,
  acceptOrderByCustomer,
  resetOrderStatus,
  getSpecialOrdersNewPendingService,
} = require("../services/specialOrder.service");
const path = require("path");
const fs = require("fs");
// Multer setup for file uploads
const multer = require("multer");
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = path.join(__dirname, "..", "assets", "specialOrders");
    // Ensure directory exists
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now();
    cb(null, `bouquet_${uniqueSuffix}.glb`); // Name the file dynamically
  },
});

const upload = multer({ storage });

// Save special order with file upload
const saveBouquetCustomization = async (req, res) => {
  try {
    const { selectedAssets, flowerCount } = req.body;

    // Extract the uploaded file name
    const fileName = req.file ? req.file.filename : null;

    // Save bouquet customization with file details
    const bouquet = new SpecialOrderModel({
      selectedAssets: JSON.parse(selectedAssets), // Parse the selectedAssets array from string
      flowerCount,

      fileName, // Store the uploaded file name
    });

    // Save to database
    await bouquet.save();

    // Respond with success message
    res
      .status(200)
      .json({ message: "Special order saved successfully", bouquet });
  } catch (error) {
    console.error("Error saving special order:", error);
    res.status(500).json({ message: "Error saving Special order" });
  }
};
const getDeviceTokenByUsername = async (username) => {
  // Assuming you have a collection to store device tokens
  const user = await UserModel.findOne({ username });
  return user?.deviceToken;
};

const getPendingOrders = async (req, res) => {
  try {
    const { customerUsername } = req.body;

    if (!customerUsername) {
      return res.status(400).json({ message: "Customer username is required" });
    }

    const orders = await fetchPendingOrdersByCustomer(customerUsername);

    if (orders.length === 0) {
      return res.status(404).json({ message: "No pending orders found" });
    }

    return res.status(200).json(orders);
  } catch (error) {
    console.error("Error fetching pending orders:", error);
    return res.status(500).json({ message: "Internal server error" });
  }
};

const updateSpecialOrder = async (req, res) => {
  try {
    const { username, orderName } = req.body; // Get username and order name from the request body

    // Delegate the update logic to the service
    const updatedOrder = await updateLatestSpecialOrder(username, orderName);
    if (!updatedOrder) {
      return res.status(404).json({ message: "No special orders found" });
    }

    // Fetch all users with a "business" role
    const businessUsers = await UserModel.find({ role: "Business" });
    console.log("Business users:", businessUsers);
    const businessUsernames = businessUsers.map((user) => user.username);

    // Send notifications to all business users
    const notificationPromises = businessUsernames.map((businessUsername) =>
      NotificationService.createNotification(
        businessUsername,
        "New Special Order",
        `A new special order has been placed by ${username}`
      )
    );

    // Send push notifications to their device tokens
    const pushNotificationPromises = businessUsers.map(async (user) => {
      const deviceToken = await getDeviceTokenByUsername(user.username);
      if (deviceToken) {
        return sendPushNotification(
          deviceToken,
          "New Special Order",
          `A new special order has been placed by ${username}`
        );
      }
    });

    // Wait for all notifications to be sent
    await Promise.all([...notificationPromises, ...pushNotificationPromises]);

    return res.status(200).json(updatedOrder); // Return the updated order
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Internal server error" });
  }
};

// Function to fetch all unassigned orders
const getUnassignedOrders = async (req, res) => {
  try {
    const orders = await SpecialOrderModel.find({
      businessUsername: "Unassigned",
    });
    res.status(200).json(orders); // Respond with the list of unassigned orders
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error fetching orders", error: error.message });
  }
};
const resetOrder = async (req, res) => {
  const { id } = req.params;

  try {
    const updatedOrder = await resetOrderStatus(id);
    res.status(200).json({
      success: true,
      message:
        "Order status reset to New and business username set to Unassigned",
      order: updatedOrder,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};
const getSpecialOrdersNewPending = async (req, res) => {
  try {
    const { businessUsername } = req.query;

    // Validate the businessUsername value
    if (!businessUsername) {
      return res.status(400).json({ error: "Business username is required" });
    }

    // Fetch bouquets with status 'New' or 'Pending', and businessUsername not matching the provided one
    const bouquets = await getSpecialOrdersService(businessUsername);
    res.status(200).json(bouquets);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
// Get special orders based on choice
const getSpecialOrders = async (req, res) => {
  try {
    let { status, businessUsername, businessUsernameOpp } = req.query;
    // If status is a string, split it into an array
    if (typeof status === "string") {
      status = status.split(",");
    }
    // Validate that statuses are valid if provided
    const validStatuses = ["New", "Assigned"];
    if (status && !status.every((s) => validStatuses.includes(s))) {
      return res.status(400).json({ error: "Invalid status value(s)" });
    }

    // Fetch the bouquets based on status and businessUsername (if provided)
    const bouquets = await getSpecialOrdersService(
      status,
      businessUsername,
      businessUsernameOpp
    );
    res.status(200).json(bouquets);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
const acceptOrder = async (req, res) => {
  const { id } = req.params;

  try {
    const updatedOrder = await acceptOrderByCustomer(id);
    res.status(200).json({
      success: true,
      message: "Order status updated to AcceptedByCustomer",
      order: updatedOrder,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};
const updateBusinessUsername = async (req, res) => {
  try {
    const { id } = req.params; // Extract the bouquet ID from the request parameters
    const { businessUsername, price } = req.body; // Extract businessUsername and price from the request body

    // Validate input
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: "Invalid bouquet ID format" });
    }

    if (!businessUsername) {
      return res.status(400).json({ message: "Business username is required" });
    }

    if (!price) {
      return res.status(400).json({ message: "Price is required" });
    }

    // Find the bouquet with status "New" and update the businessUsername, price, and status to "Pending"
    const updatedBouquet = await SpecialOrderModel.findOneAndUpdate(
      { _id: id, status: "New" }, // Find bouquet by ID and ensure status is "New"
      { businessUsername, price, status: "Pending" }, // Update the businessUsername, price, and change the status to "Pending"
      { new: true } // Return the updated document
    );

    if (!updatedBouquet) {
      return res
        .status(404)
        .json({ message: "Bouquet not found or not in New status" });
    }

    res.status(200).json({
      message: "Business username and price updated, status changed to Pending",
      bouquet: updatedBouquet,
    });
  } catch (error) {
    console.error("Error updating business username and price:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

module.exports = {
  saveBouquetCustomization,
  updateSpecialOrder,
  upload,
  getUnassignedOrders,
  updateBusinessUsername,
  getSpecialOrders,
  getPendingOrders,
  acceptOrder,
  resetOrder,
  getSpecialOrdersNewPending,
};
