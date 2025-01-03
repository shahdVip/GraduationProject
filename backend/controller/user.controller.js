const UserService = require("../services/user.services");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt"); // Import bcrypt for password hashing
const nodemailer = require("nodemailer");
require("dotenv").config(); // Load .env file
const moment = require("moment"); // For handling date and time
const crypto = require("crypto");

const jwtSecretKey = process.env.JWT_SECRET_KEY;

const User = require("../model/user.model"); // Make sure to import your User model

// New function to update profile photo
exports.updateProfilePhoto = async (req, res) => {
  try {
    // Extract the username from the token
    const token = req.header("Authorization")?.replace("Bearer ", "");
    if (!token) {
      return res
        .status(401)
        .json({ message: "Access Denied. No token provided." });
    }

    const decoded = jwt.verify(token, jwtSecretKey);
    if (!decoded || !decoded.username) {
      return res.status(401).json({ message: "Invalid or expired token" });
    }

    const username = decoded.username;

    // Check if there is a file uploaded
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    // Construct the new profile photo URL
    const newProfilePhotoUrl = `${req.protocol}://${req.get("host")}/uploads/${
      req.file.filename
    }`;

    // Find the user by username and update the profile photo
    const user = await User.findOneAndUpdate(
      { username },
      { profilePhoto: newProfilePhotoUrl },
      { new: true } // Return the updated user document
    );

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res
      .status(200)
      .json({
        message: "Profile photo updated successfully",
        profilePhoto: user.profilePhoto,
      });
  } catch (error) {
    console.error("Error updating profile photo:", error);
    res.status(500).json({ message: "Failed to update profile photo" });
  }
};

// Configure Nodemailer
const transporter = nodemailer.createTransport({
  service: "Gmail", // You can change this to another service if needed
  auth: {
    user: "shsalahat2002@gmail.com", // Replace with your email
    pass: "hjtn nbfr capf pszj", // Replace with your email password or an app-specific password
  },
});
// exports.register = async (req, res) => {
//   try {
//     // Extracting fields from the request body
//     const { email, password, address, phoneNumber, username, role } = req.body;

//     // Check if there is a file uploaded
//     let profilePhotoUrl = '';
//     if (req.file) {
//       // Construct the URL for the image
//       profilePhotoUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
//     }
//     // Check if the email or username already exists
//     const existingUser = await User.findOne({
//         $or: [{ email }, { username }],
//       });

//       if (existingUser) {
//         return res.status(409).json({ message: 'User already exists' });
//       }
//     // Create a new user instance
//     const newUser = new User({
//       email,
//       password,
//       address,
//       phoneNumber,
//       username,
//       role,
//       profilePhoto: profilePhotoUrl, // Save the image URL in the database
//     });

//     // Save the user in the database
//     await newUser.save();

//     res.status(200).json({ message: 'Registration successful' });
//   } catch (error) {
//     console.error('Error during registration:', error);
//     res.status(500).json({ error: 'Registration failed' });
//   }
// };

// Function to verify OTP
exports.verifyOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;

    // Find the user by email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Check if OTP is correct and not expired
    if (user.otp !== otp) {
      return res.status(400).json({ valid: false, message: "Invalid OTP" });
    } else if (moment().isAfter(user.otpExpiration)) {
      return res.status(400).json({ expired: true, message: "Expired OTP" });
    }

    // OTP is valid
    res.status(200).json({ valid: true, message: "OTP is valid" });
  } catch (error) {
    res.status(500).json({ message: "Internal server error", error });
  }
};

// Function to delete user
exports.deleteUserEmail = async (req, res) => {
  try {
    const { email } = req.body;

    // Find and delete the user by email
    const user = await User.findOneAndDelete({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Internal server error", error });
  }
};

exports.resendOtp = async (req, res) => {
  const { email } = req.body;

  try {
    // Check if the user exists
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Generate a new OTP
    const newOtp = Math.floor(100000 + Math.random() * 900000).toString(); // Example: 6-digit OTP

    // Save the OTP in the database
    user.otp = newOtp;
    await user.save();

    // Email options
    const mailOptions = {
      from: "shsalahat2002@gmail.com",
      to: email,
      subject: "Your New OTP Code",
      text: `Your OTP code is: ${newOtp}. It will expire in 10 minutes.`,
    };

    // Send the email
    await transporter.sendMail(mailOptions);

    res.status(200).json({ message: "OTP resent successfully" });
  } catch (error) {
    res.status(500).json({ message: "Failed to resend OTP", error });
  }
};

exports.registerByAmin = async (req, res) => {
  try {
    const { email, password, address, phoneNumber, username, role } = req.body;
    let profilePhotoUrl = "";

    // Handle profile photo URL if a file is uploaded
    if (req.file) {
      profilePhotoUrl = `${req.protocol}://${req.get("host")}/uploads/${
        req.file.filename
      }`;
    }

    // Check if the email or username already exists
    const existingUser = await User.findOne({
      $or: [{ email }, { username }],
    });

    if (existingUser) {
      return res.status(409).json({ message: "User already exists" });
    }

    // // Generate OTP
    // const otp = Math.floor(100000 + Math.random() * 900000).toString(); // 6-digit OTP
    // const otpExpiration = new Date(Date.now() + 15 * 60 * 1000); // OTP expires in 15 minutes

    // Create a new user instance
    const newUser = new User({
      email,
      password,
      address,
      phoneNumber,
      username,
      role,
      profilePhoto: profilePhotoUrl,
      otp: "",
      otpExpiration: "",
      adminApproved: true,
    });

    // Save the user in the database
    await newUser.save();

    res.status(200).json({ message: "Registration successful" });
  } catch (error) {
    console.error("Error during registration:", error);
    res.status(500).json({ error: "Registration failed" });
  }

  // // Send OTP via email
  // const mailOptions = {
  //   from: 'shsalahat2002@gmail.com', // Replace with your email
  //   to: email,
  //   subject: 'Your OTP for Registration',
  //   text: `Your OTP is ${otp}. It will expire in 10 minutes.`
  // };

  // transporter.sendMail(mailOptions, async (error, info) => {
  //   if (error) {
  //     console.error('Error sending email:', error);
  //     return res.status(500).json({ error: 'Failed to send OTP email' });
  //   }
  //   console.log('Email sent:', info.response);
  //   res.status(200).json({ message: 'Registration successful, OTP sent to email' });
  //   await newUser.save();
  // });
};

exports.register = async (req, res) => {
  try {
    const { email, password, address, phoneNumber, username, role } = req.body;
    let profilePhotoUrl = "";
    const adminApproved = req.body.adminApproved === "true"; // Convert 'true' to a boolean

    // Handle profile photo URL if a file is uploaded
    if (req.file) {
      profilePhotoUrl = `${req.protocol}://${req.get("host")}/uploads/${
        req.file.filename
      }`;
    }

    // Check if the email or username already exists
    const existingUser = await User.findOne({
      $or: [{ email }, { username }],
    });

    if (existingUser) {
      return res.status(409).json({ message: "User already exists" });
    }

    // Generate OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString(); // 6-digit OTP
    const otpExpiration = new Date(Date.now() + 15 * 60 * 1000); // OTP expires in 15 minutes

    // Create a new user instance
    const newUser = new User({
      email,
      password,
      address,
      phoneNumber,
      username,
      role,
      profilePhoto: profilePhotoUrl,
      otp,
      otpExpiration,
      adminApproved,
    });

    // Save the user in the database

    // Send OTP via email
    const mailOptions = {
      from: "shsalahat2002@gmail.com", // Replace with your email
      to: email,
      subject: "Your OTP for Registration",
      text: `Your OTP is ${otp}. It will expire in 10 minutes.`,
    };

    transporter.sendMail(mailOptions, async (error, info) => {
      if (error) {
        console.error("Error sending email:", error);
        return res.status(500).json({ error: "Failed to send OTP email" });
      }
      console.log("Email sent:", info.response);
      res
        .status(200)
        .json({ message: "Registration successful, OTP sent to email" });
      await newUser.save();
    });
  } catch (error) {
    console.error("Error during registration:", error);
    res.status(500).json({ error: "Registration failed" });
  }
};

exports.signIn = async (req, res) => {
  try {
    const { username, password } = req.body;

    // Check if the user exists
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Check if the password is correct
    const isMatch = await user.comparePassword(password); // Assume you have a `comparePassword` method in your User model
    if (!isMatch) {
      return res.status(401).json({ message: "Invalid password" });
    }

    if (!user.adminApproved) {
      return res.status(403).json({ message: "Account not approved by admin" });
    }

    // If authentication is successful, generate the JWT token
    const token = jwt.sign(
      { username: user.username },
      process.env.JWT_SECRET_KEY,
      { expiresIn: "1h" }
    );

    // Send the token to the client
    res.status(200).json({
      message: "Sign-in successful",
      token, // Send the generated token
      role: user.role,
      username: user.username,
    });
  } catch (error) {
    console.error("Error during sign-in:", error);
    res.status(500).json({ message: "Sign-in failed" });
  }
};

// Middleware to verify the JWT token
exports.verifyToken = (req, res, next) => {
  const token = req.headers["authorization"]?.split(" ")[1]; // Extract token from Authorization header

  if (!token) {
    return res.status(403).json({ message: "Token is required" });
  }

  // Verify the token using jwt.verify
  jwt.verify(token, jwtSecretKey, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: "Invalid or expired token" });
    }

    // Attach the decoded user data to the request object
    req.user = decoded;
    next(); // Proceed to the next middleware or route handler
  });
};

// Controller function to update the address
exports.updateAddress = async (req, res) => {
  const { address } = req.body;
  const username = req.user.username; // Retrieved from token by middleware

  if (!address) {
    return res.status(400).json({ error: "Address is required" });
  }

  try {
    const updatedUser = await UserService.updateUserAddress(username, address);
    if (!updatedUser) {
      return res.status(404).json({ error: "User not found" });
    }

    res
      .status(200)
      .json({ message: "Address updated successfully", user: updatedUser });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ error: "An error occurred while updating the address" });
  }
};

// Get logged-in user's information
exports.getLoggedInUserInfo = async (req, res) => {
  try {
    // Get token from Authorization header
    const token = req.header("Authorization")?.replace("Bearer ", "");

    if (!token) {
      return res
        .status(401)
        .json({ message: "Access Denied. No token provided." });
    }

    // Verify the token and extract the username
    const decoded = jwt.verify(token, process.env.JWT_SECRET_KEY);

    if (!decoded || !decoded.username) {
      return res.status(401).json({ message: "Invalid or expired token" });
    }

    // Fetch the user from the database by username (since you don't use userId)
    const user = await User.findOne({ username: decoded.username });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Return user data
    res.status(200).json({
      username: user.username,
      email: user.email,
      address: user.address,
      phoneNumber: user.phoneNumber,
      profilePhoto: user.profilePhoto,
      role: user.role,
    });
  } catch (error) {
    console.error("Error fetching user info:", error);
    res.status(500).json({ message: "Failed to fetch user info" });
  }
};

exports.updatePhoneNumber = async (req, res) => {
  try {
    const { phoneNumber } = req.body; // Get the new phone number from the request body
    const username = req.user.username; // Extract the username from the decoded token

    // Find the user and update the phone number
    const user = await User.findOneAndUpdate(
      { username },
      { phoneNumber },
      { new: true } // Return the updated user document
    );

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res
      .status(200)
      .json({ message: "Phone number updated successfully", user });
  } catch (error) {
    console.error("Error updating phone number:", error);
    res.status(500).json({ message: "Failed to update phone number" });
  }
};
exports.updatePassword = async (req, res) => {
  try {
    const { username } = req.user; // Extract the username from the token (req.user is set by your verifyToken middleware)
    const { newPassword } = req.body; // Get the new password from the request body

    // Validate the new password (you can add more complex validation if needed)
    const passwordRegex =
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
    if (!newPassword || !passwordRegex.test(newPassword)) {
      return res.status(400).json({
        message: "Weak password!",
      });
    }

    // Hash the new password
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Find the user by username and update the password
    const user = await User.findOneAndUpdate(
      { username },
      { password: hashedPassword },
      { new: true } // Return the updated user document
    );

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json({ message: "Password updated successfully" });
  } catch (error) {
    console.error("Error updating password:", error);
    res.status(500).json({ message: "Failed to update password" });
  }
};

exports.deleteAdminByUsername = async (req, res) => {
  try {
    const { username } = req.body;
    const token = req.headers.authorization?.split(" ")[1];

    if (!token) {
      return res
        .status(401)
        .json({ message: "Unauthorized: No token provided" });
    }

    // Decode the token to get the logged-in username
    const decoded = jwt.verify(token, process.env.JWT_SECRET_KEY);
    const loggedInUsername = decoded.username;

    // Check if the username to be deleted is the same as the logged-in admin's username
    if (username === loggedInUsername) {
      return res
        .status(403)
        .json({ message: "You cannot delete the logged-in admin" });
    }

    // Find the user in the database
    const user = await User.findOne({ username });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Check if the user's role is 'admin'
    if (user.role !== "Admin") {
      return res
        .status(403)
        .json({ message: "Only admin users can be deleted" });
    }

    // Delete the user
    await User.deleteOne({ username });
    res.status(200).json({ message: "Admin deleted successfully" });
  } catch (error) {
    console.error("Error deleting admin:", error);
    res.status(500).json({ message: "An error occurred" });
  }
};
// Function to create a new admin

exports.createAdmin = async (req, res) => {
  try {
    // Extracting fields from the request body
    const { email, password, address, phoneNumber, username, role } = req.body;

    // Check if there is a file uploaded
    let profilePhotoUrl = "";
    if (req.file) {
      // Construct the URL for the image
      profilePhotoUrl = `${req.protocol}://${req.get("host")}/uploads/${
        req.file.filename
      }`;
    }
    // Check if the email or username already exists
    const existingUser = await User.findOne({
      $or: [{ email }, { username }],
    });

    if (existingUser) {
      return res.status(409).json({ message: "User already exists" });
    }
    // Create a new user instance
    const newUser = new User({
      email,
      password,
      address,
      phoneNumber,
      username,
      role: "Admin",
      profilePhoto: profilePhotoUrl, // Save the image URL in the database
    });

    // Save the user in the database
    await newUser.save();

    res.status(200).json({ message: "New admin registered" });
  } catch (error) {
    console.error("Error during registration:", error);
    res.status(500).json({ error: "Registration failed" });
  }
};

// Controller to fetch all admin-approved customers
exports.getAdminApprovedCustomers = async (req, res) => {
  try {
    const customers = await User.find({
      role: "Customer",
      adminApproved: true,
    });
    res.status(200).json(customers);
  } catch (error) {
    res
      .status(500)
      .json({ error: "Failed to fetch admin-approved customers." });
  }
};

// Controller to fetch all admin-approved businesses
exports.getAdminApprovedBusinesses = async (req, res) => {
  try {
    const businesses = await User.find({
      role: "Business",
      adminApproved: true,
    });
    res.status(200).json(businesses);
  } catch (error) {
    res
      .status(500)
      .json({ error: "Failed to fetch admin-approved businesses." });
  }
};

// Controller to fetch all not admin-approved users
exports.getNotAdminApprovedUsers = async (req, res) => {
  try {
    const notApprovedUsers = await User.find({ adminApproved: false });
    res.status(200).json(notApprovedUsers);
  } catch (error) {
    res
      .status(500)
      .json({ error: "Failed to fetch not admin-approved users." });
  }
};

// Controller to fetch all users
exports.getAllUsers = async (req, res) => {
  try {
    const allUsers = await User.find();
    res.status(200).json(allUsers);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch all users." });
  }
};

// Controller to update user information
exports.updateUser = async (req, res) => {
  const { username } = req.params;
  const { email, phoneNumber, address, password } = req.body;

  try {
    // Check if there is a file uploaded
    if (req.file) {
      // Construct the new profile photo URL
      const newProfilePhotoUrl = `${req.protocol}://${req.get(
        "host"
      )}/uploads/${req.file.filename}`;

      // Find the user by username and update the profile photo URL
      const user = await User.findOneAndUpdate(
        { username },
        { profilePhoto: newProfilePhotoUrl },
        { new: true } // Return the updated user document
      );

      // Update other fields if provided
      if (email) user.email = email;
      if (phoneNumber) user.phoneNumber = phoneNumber;
      if (address) user.address = address;
      if (password) {
        const hashedPassword = await bcrypt.hash(password, 10);
        user.password = hashedPassword;
      }

      // Save any other updates
      await user.save();

      return res
        .status(200)
        .json({ message: "User updated successfully", user });
    } else {
      return res.status(400).json({ message: "No file uploaded" });
    }
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error updating user", error: error.message });
  }
};

// Controller to delete a user
exports.deleteUser = async (req, res) => {
  const { username } = req.body;

  try {
    // Find and delete the user by username
    const user = await User.findOneAndDelete({ username });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error deleting user", error: error.message });
  }
};

// Function to handle sending password reset email with OTP
exports.sendPasswordResetOtp = async (req, res) => {
  const { email } = req.body;

  // Find the user by email
  const user = await User.findOne({ email });

  if (!user) {
    return res.status(400).send("User not found");
  }

  // Generate a 6-digit OTP
  const otp = Math.floor(100000 + Math.random() * 900000).toString();

  // Set the expiration time for the OTP (e.g., 10 minutes)
  const expirationTime = Date.now() + 10 * 60 * 1000;

  // Save the OTP and expiration time to the user's record
  user.resetPasswordOtp = otp;
  user.resetPasswordOtpExpires = expirationTime;
  await user.save();

  // Set up the mail transport (e.g., using nodemailer)
  const transporter = nodemailer.createTransport({
    service: "Gmail", // You can change this to another service if needed
    auth: {
      user: "shsalahat2002@gmail.com", // Replace with your email
      pass: "hjtn nbfr capf pszj", // Replace with your email password or an app-specific password
    },
  });

  // Send the email with the OTP
  const mailOptions = {
    to: email,
    from: "shsalahat2002@gmail.com",
    subject: "Password Reset OTP",
    text: `Your password reset OTP is: ${otp}\n\nThis OTP is valid for 10 minutes.`,
  };

  transporter.sendMail(mailOptions, (err, info) => {
    if (err) {
      return res.status(500).send("Error sending email");
    }
    res.status(200).send("Password reset OTP sent");
  });
};
// Function to reset the password using OTP
exports.resetPasswordWithOtp = async (req, res) => {
  const { email, otp, newPassword } = req.body;

  // Find the user with the email and check if the OTP is valid
  const user = await User.findOne({
    email,
    resetPasswordOtp: otp,
    resetPasswordOtpExpires: { $gt: Date.now() }, // Check if OTP is not expired
  });

  if (!user) {
    return res.status(400).send("Invalid or expired OTP");
  }

  // Update the password and clear the OTP fields
  user.password = newPassword;
  user.resetPasswordOtp = undefined; // Clear the OTP
  user.resetPasswordOtpExpires = undefined; // Clear the expiration time
  await user.save();

  res.status(200).send("Password reset successfully");
};

// Controller function to update the address
exports.updateAddress = async (req, res) => {
  const { address } = req.body;
  const username = req.user.username; // Retrieved from token by middleware

  if (!address) {
    return res.status(400).json({ error: "Address is required" });
  }

  try {
    const updatedUser = await UserService.updateUserAddress(username, address);
    if (!updatedUser) {
      return res.status(404).json({ error: "User not found" });
    }

    res
      .status(200)
      .json({ message: "Address updated successfully", user: updatedUser });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ error: "An error occurred while updating the address" });
  }
};
exports.getUserSummary = async (req, res) => {
  try {
    const totalUsers = await User.countDocuments({});
    const adminCount = await User.countDocuments({ role: 'Admin' });
    const customerCount = await User.countDocuments({ role: 'Customer' });
    const businessCount = await User.countDocuments({ role: 'Business' });

    res.json({
      totalUsers,
      adminCount,
      customerCount,
      businessCount,
    });
  } catch (err) {
    res.status(500).send({ error: err.message });
  }
};
// Fetch user info by username
exports.getUserByUsername = async (req, res) => {
  try {
    const { username } = req.params; // Extract username from request parameters

    // Search for the user in the database
    const user = await User.findOne({ username });

    if (!user) {
      // If user is not found
      return res.status(404).json({ message: "User not found" });
    }

    // Respond with user information
    res.status(200).json({
      username: user.username,
      email: user.email,
      phoneNumber: user.phoneNumber,
      address: user.address,
      profilePhoto: user.profilePhoto,
      role: user.role,
    });
  } catch (error) {
    // Handle server errors
    console.error("Error fetching user:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};
