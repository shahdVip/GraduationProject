const express = require("express");
const router = express.Router();
const Moment = require("../model/moment.model");

// GET all moments
router.get("/", async (req, res) => {
  try {
    const moments = await Moment.find();
    console.log("Moments fetched from database:", moments); // Add this for debugging
    res.status(200).json(moments);
  } catch (err) {
    console.error("Error fetching moments:", err); // Log errors
    res.status(500).json({ error: "Failed to fetch moments" });
  }
});


module.exports = router;
