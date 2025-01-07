const express = require("express");
const offerController = require("../controller/offer.controller");

const router = express.Router();

// Create an offer
router.post("/", offerController.createOffer);

// Get all offers
router.get("/", offerController.getAllOffers);

// POST route to fetch offers by customerUsername
router.post("/customer", offerController.getOffersByCustomerUsername);

router.put("/order/update", offerController.updateOrderAndDeleteOffers); //accept offer

router.delete("/deny/:offerId", offerController.deleteOfferById);

// Define the POST route to fetch offers by businessUsername
router.post("/by-business", offerController.getOffersByBusiness);

module.exports = router;
