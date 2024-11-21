// controllers/userRequest.controller.js
const userRequestService = require('../services/userRequest.service');

// const createUserRequest = async (req, res) => {
//   try {
//     const userData = req.body;
//     const newUserRequest = await userRequestService.createUserRequest(userData);
//     res.status(201).json(newUserRequest);
//   } catch (error) {
//     res.status(500).json({ error: 'Failed to create user request.' });
//   }
// };

const User = require('../model/user.model'); // Import the user model
const UserRequest = require('../model/userRequest.model'); // Import the userRequest model

const createUserRequest = async(req, res)=> {
  const { email } = req.body; // Email passed in the request body

  try {
    // Fetch user details based on the email
    const user = await User.findOne({ email: email });
    
    // If the user doesn't exist, return an error
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Extract user details (username, role, profile photo)
    const { username, role, profilePhoto } = user;

    // Now, create the userRequest document with the fetched user data
    const userRequest = await userRequestService.createUserRequest({
      email: email,
      username: username,
      role: role,
      profilePhoto: profilePhoto,
      status: 'pending', // Initially set status to 'pending'
      createdAt: new Date(),
    });

    // Save the userRequest document to the database
    await userRequest.save();

    // Respond with a success message
    return res.status(200).json({ message: 'User request created successfully' });
    
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'An error occurred', error: error.message });
  }
}


const getUserRequests = async (req, res) => {
  try {
    const userRequests = await userRequestService.getAllUserRequests();
    res.status(200).json(userRequests);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch user requests.' });
  }
};

const approveUser = async (req, res) => {
  try {
    const { username } = req.body;
    await userRequestService.approveUser(username);
    res.status(200).json({ message: 'User approved successfully.' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to approve user.' });
  }
};

const denyUser = async (req, res) => {
  try {
    const { username } = req.body;
    await userRequestService.denyUser(username);
    res.status(200).json({ message: 'User denied and removed successfully.' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to deny user.' });
  }
};

module.exports = {
  createUserRequest,
  getUserRequests,
  approveUser,
  denyUser,
};
