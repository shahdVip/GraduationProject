// const mongoose = require('mongoose');

// const connection = mongoose.createConnection('mongodb+srv://s12028433:Bgy5FM4dvXs0d0c9@rozecluster0.vgbnq.mongodb.net/RozeDatabase?retryWrites=true&w=majority').on('open', () => {
//     console.log("mongodb connected..");
// }).on('error', () => {
//     console.log("mongodb connection error..");
// });


// module.exports = connection;
const mongoose = require('mongoose');

const dbURI = 'mongodb+srv://Sewar:securepasswordsewar@rozecluster0.vgbnq.mongodb.net/RozeDatabase?retryWrites=true&w=majorit';

const connectDB = async () => {
  try {
    await mongoose.connect(dbURI); // No need for deprecated options
    console.log("MongoDB connected...");
  } catch (error) {
    console.error("MongoDB connection error:", error.message);
    process.exit(1); // Exit if connection fails
  }
};

// Call the function to connect
connectDB();

// Graceful exit logic for closing the connection
const gracefulExit = async () => {
  try {
    await mongoose.connection.close(); // Updated to use a promise
    console.log("MongoDB connection closed.");
    process.exit(0); // Exit the process
  } catch (error) {
    console.error("Error closing MongoDB connection:", error.message);
    process.exit(1); // Exit with error code
  }
};

process.on('SIGINT', gracefulExit); // Handle Ctrl+C
process.on('SIGTERM', gracefulExit); // Handle termination signals
// nn

module.exports = mongoose;