const express = require("express");
const specialOrderController = require("../controller/specialOrder.controller");

const router = express.Router();
//router.post("/save", saveBouquetCustomization);
router.post(
  "/save",
  specialOrderController.upload.single("file"), // Middleware for file upload
  specialOrderController.saveBouquetCustomization
);

router.put("/updateSpecialOrder", specialOrderController.updateSpecialOrder);

module.exports = router;
