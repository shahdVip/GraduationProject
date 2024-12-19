const express = require("express");
const fileController = require("../controller/specialOrderFile.controller");

const router = express.Router();

// POST route to save a file
router.post("/save-file", fileController.saveFile);

module.exports = router;
