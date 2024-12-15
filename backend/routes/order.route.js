const express = require('express');
const { getOrdersByBusiness,
    getTotalPriceByBusiness,
    getOrderItemsByBusiness,
    updateOrderStatus,
    DenyOrder,
    getOrdersByBusinessAndStatus } = require('../controller/order.controller');

const router = express.Router();

// Route to fetch colors
router.get('/business/:name', getOrdersByBusiness);
router.get('/business/:businessName/:status', getOrdersByBusinessAndStatus);
router.get('/:orderId/business/:businessName/totalPrice',getTotalPriceByBusiness);
router.get('/:orderID/business/:businessUsername/items', getOrderItemsByBusiness);
router.put('/:orderId/business/:businessUsername/updateStatus', updateOrderStatus);
router.put('/:orderId/business/:businessName/DenyOrder', DenyOrder);
module.exports = router;
