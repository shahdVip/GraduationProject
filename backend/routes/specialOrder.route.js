const express = require("express");
const {
  saveBouquetCustomization,
  updateSpecialOrder,
} = require("../controller/specialOrder.controller");

const router = express.Router();
router.post("/save", saveBouquetCustomization);

router.put("/updateSpecialOrder", updateSpecialOrder);

module.exports = router;
