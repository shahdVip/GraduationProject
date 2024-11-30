const express = require('express');
const body_parser = require('body-parser');
const path = require('path');
const cors = require("cors");
const userRoute = require('./routes/user.route');
const userRequestRoutes = require('./routes/userRequest.route');
const userPreferenceRoutes = require('./routes/userPreference.route');
const itemRoutes = require('./routes/item.route');
const momentRoutes = require("./routes/moments.route");
const cartRoutes = require('./routes/userCart.route');


require('dotenv').config(); // To load environment variables

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use(body_parser.json());



// Routes
app.use('/', userRoute);
app.use('/userRequests', userRequestRoutes);
app.use('/userPreference', userPreferenceRoutes); // Add the user preference routes
app.use("/moments", momentRoutes);
app.use('/item', itemRoutes);
app.use('/cart', cartRoutes);



module.exports = app;
