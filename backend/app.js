const express = require("express");
const body_parser = require("body-parser");
const path = require("path");
const cors = require("cors");
const userRoute = require("./routes/user.route");
const userRequestRoutes = require("./routes/userRequest.route");
const userPreferenceRoutes = require("./routes/userPreference.route");
const itemRoutes = require("./routes/item.route");
const momentRoutes = require("./routes/moments.route");
const cartRoutes = require("./routes/userCart.route");
const inventoryRoutes = require("./routes/inventory.route");
const colorRoutes = require("./routes/color.route");
const flowerTypeRoutes = require("./routes/flowerType.route");
const tagRoutes = require("./routes/tag.route");
const orderRoutes = require("./routes/order.route");
const cartRoutes = require("./routes/userCart.route");
const inventoryRoutes = require("./routes/inventory.route");
const specialOrdersRoutes = require("./routes/specialOrder.route");

const mongoose = require("mongoose");

const customizationAssetsModel = require("./model/customizationAssets.model");
const customizationGroupsModel = require("./model/customizationGroups.model");
const customizationPalettesModel = require("./model/customizationPalettes.model");
const router = express.Router();

require("dotenv").config(); // To load environment variables

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
// Serve static assets
app.use("/assets", express.static("assets"));

app.use("/uploads", express.static(path.join(__dirname, "uploads")));
app.use(
  "/uploadsFlowers",
  express.static(path.join(__dirname, "uploadsFlowers"))
);

app.use(body_parser.json());
app.use(
  "/uploadsFlowers",
  express.static(path.join(__dirname, "uploadsFlowers"))
);

// Routes
app.use("/", userRoute);
app.use("/userRequests", userRequestRoutes);
app.use("/userPreference", userPreferenceRoutes); // Add the user preference routes
app.use("/moments", momentRoutes);
app.use("/item", itemRoutes);
app.use("/orders", orderRoutes);

app.use("/cart", cartRoutes);
app.use("/inventory", inventoryRoutes);
app.use("/colors", colorRoutes);
app.use("/flowerTypes", flowerTypeRoutes);
app.use("/tags", tagRoutes);
app.use("/item", itemRoutes);
app.use("/cart", cartRoutes);
app.use("/inventory", inventoryRoutes);
app.use("/specialOrder", specialOrdersRoutes);

// Test route to insert initial data
app.get("/create-test-data", async (req, res) => {
  try {
    const asset = new customizationAssetsModel({
      name: "vase1", // Name of the asset
      thumbnail: "backend/assets/thumbnails/vase1.jpg", // Path to the thumbnail
      url: "backend/assets/3dmodels/vase_1.glb", // Path to the 3D model file
      group: "67574f8d43d9f8e2f19efaa0", // ID for the 'Greenery' group
    });

    await asset.save();

    res.send("Asset data created successfully!");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error creating asset data");
  }
});

// Route to get categories with populated data
app.get("/categories", async (req, res) => {
  try {
    const categories = await customizationGroupsModel
      .find()
      .populate("colorPalette"); // Populate colorPalette inside the customization group
    res.json(categories);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Fetch all groups with their assets
app.get("/groups-with-assets", async (req, res) => {
  try {
    const groups = await customizationGroupsModel
      .find()
      .populate("colorPalette") // If you need colorPalette details
      .lean(); // Fetch groups

    const groupIds = groups.map((group) => group._id);

    // Fetch all assets belonging to these groups
    const assets = await customizationAssetsModel
      .find({
        group: { $in: groupIds },
      })
      .lean();

    // Map assets to their respective groups
    const groupsWithAssets = groups.map((group) => {
      return {
        ...group,
        assets: assets.filter(
          (asset) => asset.group.toString() === group._id.toString()
        ),
      };
    });

    res.json(groupsWithAssets);
  } catch (err) {
    console.error(err);
    res.status(500).send("Server Error");
  }
});

module.exports = app;
