const express = require("express");
const router = express.Router();
const Moment = require("../model/moment.model");
const Tag = require('../model/tag.model');

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
router.delete('/deleteMoments/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Find the moment by ID
    const moment = await Moment.findById(id);

    if (!moment) {
      return res.status(404).json({ message: 'Moment not found' });
    }

    // Delete the moment
    await Moment.findByIdAndDelete(id);

    // Check if the text exists in the Tags collection
    const tagToDelete = await Tag.findOne({ tag: moment.text });

    if (tagToDelete) {
      await Tag.findByIdAndDelete(tagToDelete._id);
      console.log(`Tag "${moment.text}" deleted from Tags collection.`);
    } else {
      console.log(`Tag "${moment.text}" not found in Tags collection.`);
    }

    res.status(200).json({ message: 'Moment and associated tag deleted successfully' });

  } catch (error) {
    console.error('Error deleting moment:', error);
    res.status(500).json({ message: 'Error deleting moment', error });
  }
});


const multer = require("multer");

// Multer setup for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/moments"); // Set upload directory
  },
  filename: function (req, file, cb) {
    cb(null, `${Date.now()}-${file.originalname}`);
  },
});
const upload = multer({ storage });

// POST API to add a new moment
router.post("/addMoment", upload.single("image"), async (req, res) => {
  try {
    console.log("Received Body:", req.body); // Log text fields
    console.log("Received File:", req.file); // Log file details

    const { text } = req.body;

    // Validate text field
    if (!text || text.trim().length === 0) {
      return res.status(400).json({ message: "Text is required to add a moment." });
    }

    // Validate uploaded file
    if (!req.file || !req.file.mimetype.startsWith("image/")) {
      return res.status(400).json({ message: "Uploaded file must be an image." });
    }

    const imageUrl = `${req.protocol}://${req.get("host")}/uploads/moments/${req.file.filename}`;
    const newMoment = new Moment({ text: text.trim(), imageUrl });

    await newMoment.save();

    res.status(201).json({
      message: "Moment added successfully",
      data: newMoment,
    });
  } catch (error) {
    console.error("Error adding moment:", error);
    res.status(500).json({ message: "Error adding moment", error });
  }
});


module.exports = router;
