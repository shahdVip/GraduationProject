// services/userRequest.service.js
const UserRequest = require('../model/userRequest.model');
const User = require('../model/user.model');
const InventoryModel = require('../model/inventory.model'); // Adjust path as necessary


const createUserRequest = async (userData) => {
  const userRequest = new UserRequest(userData);
  return await userRequest.save();
};

const deleteUserRequest = async (username) => {
  return await UserRequest.deleteOne({ username });
};

const approveUser = async (username) => {
  // Update the user's `adminApproved` field to true in the users collection
  await User.updateOne({ username }, { adminApproved: true });
  // Initialize the user's inventory
  const newInventory = new InventoryModel({
    username,
    flowers: [], // Default empty inventory
  });

  await newInventory.save();
  
  return await deleteUserRequest(username);
};

const denyUser = async (username) => {
  // Delete the user from the users collection
  await User.deleteOne({ username });
  // Remove the request from the userRequest collection
  return await deleteUserRequest(username);
};

const getAllUserRequests = async () => {
  return await UserRequest.find();
};

module.exports = {
  createUserRequest,
  deleteUserRequest,
  approveUser,
  denyUser,
  getAllUserRequests,
};
