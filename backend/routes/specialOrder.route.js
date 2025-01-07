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

// router.get("/unassigned", specialOrderController.getUnassignedOrders);

router.put(
  "/offer/:id/business-username",
  specialOrderController.updateBusinessUsername
);

// Get special orders (unassigned, by business, or based on status)
router.get("/filter", specialOrderController.getSpecialOrders);
router.get("/filter1", specialOrderController.getSpecialOrdersNewPending);

router.post("/pending", specialOrderController.getPendingOrders);
router.patch("/:id/accept", specialOrderController.acceptOrder);

router.put("/reset-order/:id", specialOrderController.resetOrder);

module.exports = router;
