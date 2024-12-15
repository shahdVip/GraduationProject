const express = require("express");
const cartController = require("../controller/userCart.controller");
const UserCartModel = require("../model/userCart.model");

const router = express.Router();

router.post("/add", cartController.addItemToCart);
router.delete("/remove/:username/:itemName", cartController.removeItemFromCart);
router.get("/:username", cartController.getCart);

module.exports = router;
