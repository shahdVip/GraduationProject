const express = require("express");
const { getCart,removeItemByIndex,addItemToCart }  = require("../controller/userCart.controller");
const {createOrder} =require("../controller/order.controller");


const router = express.Router();

router.put("/addItem", addItemToCart);
router.delete("/:username/remove/item/:index",removeItemByIndex);
router.get("/:username",getCart);
router.post("/:username/submitOrder", createOrder);


module.exports = router;