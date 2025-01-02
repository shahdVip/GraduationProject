const SpecialOrderModel = require("../model/specialOrder.model");

const updateLatestSpecialOrder = async (username) => {
  // Find the latest special order by sorting with createdAt in descending order
  const latestOrder = await SpecialOrderModel.findOne().sort({ createdAt: -1 });

  if (!latestOrder) {
    return null; // No orders found
  }

  // Update the latest order with the logged-in username
  latestOrder.customerUsername = username;
  latestOrder.createdAt = new Date();

  // Save the updated document and return it
  return await latestOrder.save();
};

module.exports = {
  updateLatestSpecialOrder,
};
