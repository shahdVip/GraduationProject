// const mongoose = require('mongoose');
// const db = require('../config/db');
// const bcrypt = require('bcrypt');

// const { Schema } = mongoose;

// const userSchema = new Schema({
//     email: {
//         type: String,
//         lowercase: true,
//         required: true,
//         unique: true
//     },
//     password: {
//         type: String,
//         required: true
//     },
//     phoneNumber: {
//         type: String,
//         required: true // Set to true if you want to make it mandatory
//     },
//     address: {
//         type: String,
//         required: true // Set to true if you want to make it mandatory
//     },
//     profilePhoto: {
//         type: String, // You can store the URL of the photo
//         required: false
//     },
//     username: {
//         type: String,
//         required: true,
//         unique: true
//     },
//     role: {
//         type: String,
//         enum: ['Admin', 'Customer', 'Business'], // Specify allowed roles
//         required: true
//     }
// });

// userSchema.pre('save',async function(){
//     try{
//         var user=this;
//         const salt = await(bcrypt.genSalt(10));
//         const hashpass = await bcrypt.hash(user.password,salt);

//         user.password=hashpass;
//     }catch(error){
//         throw error;
//     }
// });

// userSchema.methods.comparePassword = async function (inputPassword) {
//     return await bcrypt.compare(inputPassword, this.password);
//   };

// const UserModel= db.model('user',userSchema);

// module.exports = UserModel;

const mongoose = require("mongoose");
const db = require("../config/db");
const bcrypt = require("bcrypt");

const { Schema } = mongoose;

const userSchema = new Schema({
  email: {
    type: String,
    lowercase: true,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  phoneNumber: {
    type: String,
    required: true,
  },
  address: {
    type: String,
    required: true,
  },
  profilePhoto: {
    type: String,
    required: false,
  },
  username: {
    type: String,
    required: true,
    unique: true,
  },
  role: {
    type: String,
    enum: ["Admin", "Customer", "Business"],
    required: true,
  },
  otp: {
    type: String, // Store the OTP code
    required: false,
  },
  otpExpiration: {
    type: Date, // Time when the OTP expires
    required: false,
  },
  adminApproved: {
    type: Boolean,
    default: false, // Set to false by default
  },
  resetPasswordOtp: { type: String }, // For storing the reset token
  resetPasswordOtpExpires: { type: Date }, // Expiration time for the reset token
  deviceToken: { type: String }, // Store the device token
});

// Hash the password before saving
userSchema.pre("save", async function (next) {
  try {
    // Only hash the password if it is new or has been modified
    if (!this.isModified("password")) {
      return next();
    }

    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

userSchema.methods.comparePassword = async function (inputPassword) {
  const isMatch = await bcrypt.compare(inputPassword, this.password);

  if (!isMatch) {
    const salt = await bcrypt.genSalt(10);
    // Attempt to compare the password assuming it was double-hashed
    const doubleHashed = await bcrypt.hash(inputPassword, salt);

    return bcrypt.compare(doubleHashed, this.password);
  }

  return isMatch;
};

const UserModel = db.model("user", userSchema);

module.exports = UserModel;
