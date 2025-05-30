const express = require("express");

const router = require("express").Router();
const UserController = require("../controller/user.controller");
const multer = require("multer");
const User = require("../model/user.model"); // Make sure to import your User model

// Configure Multer to store images in the 'uploads' folder
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/"); // The folder where images will be stored
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + "-" + file.originalname); // Unique filename
  },
});

const upload = multer({ storage });

// Update your route to use Multer
router.post(
  "/registeration",
  upload.single("profilePhoto"),
  UserController.register
);

router.post("/signin", UserController.signIn);

router.get("/loggedInInfo", UserController.getLoggedInUserInfo);

router.put(
  "/updateProfilePhoto",
  UserController.verifyToken,
  upload.single("profilePhoto"),
  UserController.updateProfilePhoto
);

router.put(
  "/updatePhoneNumber",
  UserController.verifyToken,
  UserController.updatePhoneNumber
);

router.put(
  "/updatePassword",
  UserController.verifyToken,
  UserController.updatePassword
);

router.delete("/deleteAdmin", UserController.deleteAdminByUsername);

router.post(
  "/create-admin",
  upload.single("profilePhoto"),
  UserController.createAdmin
);

router.post("/resend-otp", UserController.resendOtp);

router.post("/verify-otp", UserController.verifyOtp);

router.post("/delete-user", UserController.deleteUserEmail);

router.post(
  "/adminUsrRegisteration",
  upload.single("profilePhoto"),
  UserController.registerByAmin
);

// Route to fetch all admin-approved customers
router.get(
  "/adminApproved/customers",
  UserController.getAdminApprovedCustomers
);

// Route to fetch all admin-approved businesses
router.get(
  "/adminApproved/businesses",
  UserController.getAdminApprovedBusinesses
);

// Route to fetch all not admin-approved users
router.get("/notAdminApproved", UserController.getNotAdminApprovedUsers);

// Route to fetch all users
router.get("/allUsers", UserController.getAllUsers);

// Route to update user information
//router.put('/updateUser/:username', UserController.updateUser);

// Route to delete a user
router.delete("/deleteUser", UserController.deleteUser);

// Add the `upload.single` middleware to handle the profile photo upload
router.put(
  "/updateUser/:username",
  upload.single("profilePhoto"),
  UserController.updateUser
);

// Route to handle sending the password reset email
router.post("/send-reset-link", UserController.sendPasswordResetOtp);

// Route to handle resetting the password
router.put("/reset-password", UserController.resetPasswordWithOtp);

router.put(
  "/update-address",
  UserController.verifyToken,
  UserController.updateAddress
);
// Endpoint to save the device token
router.post("/save-device-token", async (req, res) => {
  const { deviceToken, username } = req.body;

  if (!deviceToken || !username) {
    return res.status(400).send("Device token and username are required");
  }

  try {
    const user = await User.findOneAndUpdate(
      { username },
      { deviceToken }, // Update the user's device token
      { new: true }
    );

    if (!user) {
      return res.status(404).send("User not found");
    }

    res.status(200).send("Device token saved successfully");
  } catch (error) {
    console.error("Error saving device token:", error);
    res.status(500).send("Internal server error");
  }
});

router.get("/summaryUserCounts", UserController.getUserSummary);
router.get("/user/:username", UserController.getUserByUsername);
module.exports = router;
