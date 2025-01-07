const SpecialOrderModel = require("../model/specialOrder.model");

const updateLatestSpecialOrder = async (username, orderName) => {
  // Find the latest special order by sorting with createdAt in descending order
  const latestOrder = await SpecialOrderModel.findOne().sort({ createdAt: -1 });

  if (!latestOrder) {
    return null; // No orders found
  }

  // Update the latest order with the logged-in username and order name
  latestOrder.customerUsername = username;
  latestOrder.orderName = orderName; // Add this line to update the order name
  latestOrder.createdAt = new Date();

  // Save the updated document and return it
  return await latestOrder.save();
};

const fetchPendingOrdersByCustomer = async (customerUsername) => {
  // Fetch orders where customerUsername matches and status is 'Pending'
  return await SpecialOrderModel.find({
    customerUsername: customerUsername,
    status: "Pending",
  });
};

// Get bouquets based on status and business username (if applicable)
const getSpecialOrdersService = async (
  status,
  businessUsername = null,
  businessUsernameOpp = null
) => {
  // try {
  //   const query = {};
  //   if (status) query.status = status;
  //   if (businessUsername) query.businessUsername = businessUsername;
  //   else query.businessUsername = "Unassigned"; // For unassigned bouquets

  //   const bouquets = await SpecialOrderModel.find(query);
  //   return bouquets;
  // } catch (error) {
  //   throw new Error("Error fetching special orders: " + error.message);
  // }
  // try {
  //   const query = {};

  //   // If the status is provided and is an array, use $in to match any of the statuses
  //   if (status && status.length > 0) {
  //     query.status = { $in: status };
  //   }

  //   // If businessUsername is provided, filter by it, otherwise use "Unassigned"
  //   if (businessUsername) {
  //     query.businessUsername = businessUsername;
  //   } else {
  //     query.businessUsername = "Unassigned"; // For unassigned bouquets
  //   }

  //   const bouquets = await SpecialOrderModel.find(query);
  //   return bouquets;
  // } catch (error) {
  //   throw new Error("Error fetching special orders: " + error.message);
  // }
  try {
    const query = {};

    // Apply the status filter if present
    if (status) {
      query.status = { $in: status }; // Use `$in` for multiple status values
    }

    // If a business username is provided, match it
    if (businessUsername) {
      query.businessUsername = businessUsername;
    }

    // If `businessUsernameOpp` is provided, exclude the matching business username
    if (businessUsernameOpp) {
      query.businessUsername = { $ne: businessUsernameOpp }; // Use `$ne` for "not equal"
    }

    // Fetch bouquets based on the query
    const bouquets = await SpecialOrderModel.find(query);
    return bouquets;
  } catch (error) {
    throw new Error("Error fetching special orders: " + error.message);
  }
};

const getSpecialOrdersNewPendingService = async (businessUsername) => {
  try {
    const query = {
      status: { $in: ["New", "Pending"] }, // Fetch orders with status 'New' or 'Pending'
      businessUsername: { $ne: businessUsername }, // Ensure businessUsername is not the provided one
    };

    const bouquets = await SpecialOrderModel.find(query);
    return bouquets;
  } catch (error) {
    throw new Error("Error fetching special orders: " + error.message);
  }
};

const resetOrderStatus = async (id) => {
  try {
    const updatedOrder = await SpecialOrderModel.findByIdAndUpdate(
      id,
      {
        status: "New",
        businessUsername: "Unassigned",
      },
      { new: true } // Return the updated document
    );

    if (!updatedOrder) {
      throw new Error("Order not found");
    }

    return updatedOrder;
  } catch (error) {
    throw new Error(error.message);
  }
};

const acceptOrderByCustomer = async (id) => {
  if (!id) {
    throw new Error("_id is required");
  }

  const order = await SpecialOrderModel.findById(id);

  if (!order) {
    throw new Error("Order not found");
  }

  order.status = "AcceptedByCustomer";
  return await order.save();
};
module.exports = {
  updateLatestSpecialOrder,
  getSpecialOrdersService,
  fetchPendingOrdersByCustomer,
  acceptOrderByCustomer,
  resetOrderStatus,
  getSpecialOrdersNewPendingService,
};
