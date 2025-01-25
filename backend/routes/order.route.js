const express = require('express');
const { getOrdersByBusiness,
    getTotalPriceByBusiness,
    getOrderItemsByBusiness,
    updateOrderStatus,
    DenyOrder,
    getOrdersByBusinessAndStatus,
    getTopBusinesses,
    getOrderSummary,
    getOrdersByCustomerUsername,
    getOrderById,
    getOrderStatusForBusiness,
    updateRatings,
    getTotalPrice} = require('../controller/order.controller');

const router = express.Router();

// Route to fetch colors
router.get('/:orderId', getOrderById);
router.get('/business/:name', getOrdersByBusiness);
router.get('/business/:businessName/:status', getOrdersByBusinessAndStatus);
router.get('/:orderId/business/:businessName/totalPrice',getTotalPriceByBusiness);
router.get('/:orderID/business/:businessUsername/items', getOrderItemsByBusiness);
router.put('/:orderId/business/:businessUsername/updateStatus', updateOrderStatus);
router.put('/:orderId/business/:businessName/DenyOrder', DenyOrder);
router.get('/topBusinesses', getTopBusinesses);
router.get('/orderSummary', getOrderSummary);
router.get('/customer/:customerUsername', getOrdersByCustomerUsername);
router.get('/:orderId/business/:businessName/status', getOrderStatusForBusiness);
router.put('/updateRatings', updateRatings);
router.get('/getTotalPrice/:orderId', getTotalPrice);

module.exports = router;
