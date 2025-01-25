const Order = require('../model/order.model');
const Item = require('../model/item.model');
const UserCart = require('../model/userCart.model'); // User Cart model

const getOrdersByBusiness = async (req, res) => {
  try {
      const businessName = req.params.name;

      // Find orders where businessName exists in businessUsername array
      const orders = await Order.find({ businessUsername: { $in: [businessName] } });

      if (orders.length === 0) {
          return res.status(404).json({ message: 'No orders found for this business' });
      }

      // Map orders to include the requested structure
      const filteredOrders = orders.map(order => {
          const businessIndex = order.businessUsername.indexOf(businessName);

          // Ensure the businessName exists in businessUsername
          if (businessIndex !== -1) {
              return {
                  _id: order._id,
                  bouquetsId: order.bouquetsId,
                  customerUsername: order.customerUsername,
                  businessUsername: order.businessUsername, // Return as a list
                  totalPrice: order.totalPrice,
                  time: order.time,
                  status: order.status[businessIndex] // Return corresponding status as a string
              };
          }

          // Return null for unmatched cases
          return null;
      }).filter(order => order !== null); // Remove null values

      res.status(200).json(filteredOrders);
  } catch (error) {
      console.error('Error fetching orders by business name:', error);
      res.status(500).json({ message: 'Internal server error' });
  }
};

  const getOrderItemsByBusiness = async (req, res) => {
    const { orderID, businessUsername } = req.params;

    try {
        // Validate input
        if (!orderID || !businessUsername) {
            return res.status(400).json({ message: 'orderID and businessUsername are required' });
        }

        // Fetch the order by ID
        const order = await Order.findById(orderID);
        if (!order) {
            return res.status(404).json({ message: 'Order not found' });
        }

        // Fetch items associated with the order's bouquetsId
        const allItems = await Item.find({ _id: { $in: order.bouquetsId } });

        // Filter items by business username
        const filteredItems = allItems.filter(item => item.business === businessUsername);

        if (filteredItems.length === 0) {
            return res.status(404).json({ message: 'No items found for the specified business username in this order' });
        }

        // Respond with the filtered items
        return res.status(200).json(filteredItems);
    } catch (error) {
        console.error('Error fetching items:', error);
        return res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};


  const getTotalPriceByBusiness = async (req, res) => {
    try {
      const { orderId, businessName } = req.params;
  
      // Find the order by its ID
      const order = await Order.findById(orderId);
      if (!order) {
        return res.status(404).json({ message: 'Order not found' });
      }
  
      // Fetch all items in the order
      const items = await Item.find({ _id: { $in: order.bouquetsId } });
  
      // Filter items made by the specified business
      const businessItems = items.filter(item => item.business === businessName);
  
      // Calculate the total price
      const totalPrice = businessItems.reduce((sum, item) => {
        const count = order.bouquetsId.filter(id => id === item._id.toString()).length;
        return sum + item.price * count;
      }, 0);
  
      // Send the total price directly
      res.status(200).send(totalPrice.toString());
    } catch (error) {
      console.error('Error calculating total price:', error);
      res.status(500).json({ message: 'Internal server error' });
    }
  };

  const updateOrderStatus = async (req, res) => {
    try {
        const { orderId, businessUsername } = req.params;

        // Validate input
        if (!orderId || !businessUsername) {
            return res.status(400).json({ message: "orderId and businessUsername are required" });
        }

        // Fetch the order by ID
        const order = await Order.findById(orderId);
        if (!order) {
            return res.status(404).json({ message: "Order not found" });
        }

        // Find the index of the businessUsername in the order
        const businessIndex = order.businessUsername.indexOf(businessUsername);

        // Validate businessUsername
        if (businessIndex === -1) {
            return res.status(404).json({ message: "Business username not associated with this order" });
        }

        // Get the current status
        const currentStatus = order.status[businessIndex];

        // Determine the next status
        const nextStatus = (() => {
            switch (currentStatus) {
                case "pending":
                    return "accepted";
                case "accepted":
                    return "waiting";
                case "waiting":
                    return "done";
                default:
                    return null;
            }
        })();

        if (!nextStatus) {
            return res.status(400).json({ message: `Invalid current status: ${currentStatus}` });
        }

        // Update the status in the order
        order.status[businessIndex] = nextStatus;

        // Save the updated order
        await order.save();

        // Return the updated order
        res.status(200).json(order);
    } catch (error) {
        console.error("Error updating order status:", error);
        res.status(500).json({ message: "Internal server error" });
    }
};
const getOrdersByBusinessAndStatus = async (req, res) => {
  try {
    const { businessName, status } = req.params;

    // Validate input
    if (!businessName || !status) {
      return res.status(400).json({ message: 'businessName and status are required' });
    }

    // Find orders where businessName exists in businessUsername array
    const orders = await Order.find({ businessUsername: { $in: [businessName] } });

    if (orders.length === 0) {
      return res.status(404).json({ message: 'No orders found for this business' });
    }

    // Filter orders where the corresponding status matches
    const filteredOrders = orders.map(order => {
      const businessIndex = order.businessUsername.indexOf(businessName);

      // Ensure the businessName exists in businessUsername and the status matches
      if (businessIndex !== -1 && order.status[businessIndex] === status) {
        return {
          _id: order._id,
          bouquetsId: order.bouquetsId,
          customerUsername: order.customerUsername,
          businessUsername: order.businessUsername, // Return as a list
          totalPrice: order.totalPrice,
          time: order.time,
          status: order.status[businessIndex] // Return corresponding status as a string
        };
      }

      // Return null for unmatched cases
      return null;
    }).filter(order => order !== null); // Remove null values

    if (filteredOrders.length === 0) {
      return res.status(404).json({ message: `No orders found for business ${businessName} with status ${status}` });
    }

    res.status(200).json(filteredOrders);
  } catch (error) {
    console.error('Error fetching orders by business and status:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};
const DenyOrder = async (req, res) => {
  try {
    const { orderId, businessName } = req.params;

    // Validate input
    if (!orderId || !businessName) {
      return res.status(400).json({ message: 'orderId and businessName are required' });
    }

    // Find the order by ID
    const order = await Order.findById(orderId);
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    // Find the index of the businessName in the order
    const businessIndex = order.businessUsername.indexOf(businessName);

    // Validate that the businessName exists in the order
    if (businessIndex === -1) {
      return res.status(404).json({ message: 'Business username not associated with this order' });
    }

    // Change the status to "denied"
    order.status[businessIndex] = "denied";

    // Save the updated order
    await order.save();

    // Return the updated order
    res.status(200).json({
      message: `Status for business ${businessName} in order ${orderId} has been changed to denied.`,
      order,
    });
  } catch (error) {
    console.error('Error changing status to denied:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};
// Function to create an order from the user's cart
const createOrder = async (req, res) => {
  const { username } = req.params;

  try {
    // Step 1: Fetch the user's cart
    const userCart = await UserCart.findOne({ username });
    if (!userCart || userCart.itemsId.length === 0) {
      return res.status(404).json({ message: 'Cart is empty or not found.' });
    }

    // Step 2: Fetch bouquet details from the items collection
    const items = await Item.find({ _id: { $in: userCart.itemsId } });

    if (!items || items.length === 0) {
      return res.status(400).json({ message: 'No valid items found in the cart.' });
    }

    // Step 3: Extract business names (remove duplicates)
    const businessUsernames = [
      ...new Set(items.map((item) => item.business)), // Assuming "business" is the field for the business name
    ];

    // Step 4: Prepare order data
    const orderData = {
      bouquetsId: userCart.itemsId, // All bouquet/item IDs
      customerUsername: username,
      businessUsername: businessUsernames,
      totalPrice: items.reduce((sum, item) => sum + item.price, 0), // Sum of all prices
      time: new Date().toISOString(), // Current date and time
      status: businessUsernames.map(() => 'pending'), // One 'pending' per business
    };

    // Step 5: Create the order
    const newOrder = new Order(orderData);
    await newOrder.save();

    // Step 6: Clear the user's cart after order creation
    userCart.itemsId = [];
    await userCart.save();

    res.status(201).json({
      message: 'Order created successfully',
      order: newOrder,
    });
  } catch (error) {
    console.error('Error creating order:', error);
    res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};
  const getTopBusinesses = async (req, res) => {
    try {
      const topBusinesses = await Order.aggregate([
        { $unwind: "$businessUsername" }, // Unwind the array of business usernames
        {
          $group: {
            _id: "$businessUsername",
            orderCount: { $sum: 1 },
          },
        },
        { $sort: { orderCount: -1 } },
        { $limit: 3 },
      ]);
  
      res.json(topBusinesses);
    } catch (err) {
      res.status(500).send({ error: err.message });
    }
  };
  const getOrderSummary = async (req, res) => {
    try {
      // Fetch orders and items collections
      const orders = await Order.find({});
      const items = await Item.find({});
  
      // Calculate total orders
      const totalOrders = orders.length;
  
      // Calculate done orders
      const doneOrders = orders.filter(order =>
        order.status.every(status => status === "done")
      ).length;
  
      // Count bouquet frequency
      const bouquetFrequency = {};
      orders.forEach(order => {
        order.bouquetsId.forEach(bouquetId => {
          bouquetFrequency[bouquetId] = (bouquetFrequency[bouquetId] || 0) + 1;
        });
      });
  
      // Find the most wanted bouquet ID
      const mostWantedBouquetId = Object.keys(bouquetFrequency).reduce(
        (a, b) => (bouquetFrequency[a] > bouquetFrequency[b] ? a : b),
        null
      );
  
      // Find the name of the most wanted bouquet
      const mostWantedBouquet = items.find(
        item => item._id.toString() === mostWantedBouquetId
      );
  
      res.json({
        totalOrders,
        doneOrders,
        mostWantedBouquet: mostWantedBouquet
          ? { name: mostWantedBouquet.name, id: mostWantedBouquetId }
          : null,
      });
    } catch (err) {
      res.status(500).send({ error: err.message });
    }
  };

  const getOrdersByCustomerUsername = async (req, res) => {
    const { customerUsername } = req.params;
  
    console.log('Received customerUsername:', customerUsername);
  
    try {
      // Query orders matching the exact customerUsername (case-sensitive)
      const orders = await Order.find({
        customerUsername: customerUsername
      });
  
      console.log('Orders found:', orders);
  
      // If no orders are found, return 404
      if (orders.length === 0) {
        return res.status(404).json({ message: 'No orders found for this customer' });
      }
  
      // Return the matching orders
      res.status(200).json(orders);
    } catch (error) {
      console.error('Error fetching orders:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  const getOrderById = async (req, res) => {
    const { orderId } = req.params;
  
    console.log('Received orderId:', orderId);
  
    try {
      // Fetch the order by its ID
      const order = await Order.findById(orderId);
  
      // If no order is found, return a 404 response
      if (!order) {
        return res.status(404).json({ message: 'Order not found' });
      }
  
      // Return the found order
      res.status(200).json(order);
    } catch (error) {
      console.error('Error fetching order by ID:', error);
  
      // Handle invalid ObjectId errors
      if (error.kind === 'ObjectId') {
        return res.status(400).json({ error: 'Invalid orderId format' });
      }
  
      res.status(500).json({ error: 'Internal server error' });
    }
  };

  const getOrderStatusForBusiness = async (req, res) => {
    const { orderId, businessName } = req.params;

    try {
        // Find the order by its ID
        const order = await Order.findById(orderId);

        if (!order) {
            return res.status(404).json({ message: 'Order not found' });
        }

        // Find the index of the business name in the businessUsername array
        const businessIndex = order.businessUsername.indexOf(businessName);

        if (businessIndex === -1) {
            return res.status(404).json({ message: 'Business name not found in order' });
        }

        // Retrieve the corresponding status for the business
        const status = order.status[businessIndex];

        res.status(200).json({ status });
    } catch (error) {
        res.status(500).json({
            message: 'Error retrieving status',
            error: error.message,
        });
    }
};
const updateRatings = async (req, res) => {
  const { businessName, orderId, newRating } = req.body;

  if (!businessName || !orderId || newRating == null) {
    return res.status(400).json({ error: 'businessName, orderId, and newRating are required.' });
  }

  try {
    // Find the order by ID
    const order = await Order.findById(orderId);

    if (!order) {
      return res.status(404).json({ error: 'Order not found.' });
    }

    // Filter bouquets that belong to the specified business
    const bouquetsToUpdate = await Item.find({
      _id: { $in: order.bouquetsId },
      business: businessName,
    });

    if (bouquetsToUpdate.length === 0) {
      return res.status(404).json({ error: 'No items found for the specified business in this order.' });
    }

    // Update the rating of each item
    const updatePromises = bouquetsToUpdate.map(async (item) => {
      const updatedRating = ((item.rating * item.ratingCount) + newRating) / (item.ratingCount + 1);
      const updatedRatingCount = item.ratingCount + 1;
      return Item.findByIdAndUpdate(
        item._id,
        { rating: updatedRating, ratingCount: updatedRatingCount },
        { new: true }
      );
    });

    const updatedItems = await Promise.all(updatePromises);

    res.status(200).json({
      message: 'Ratings updated successfully.',
      updatedItems,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while updating ratings.' });
  }
};
// Import necessary modules
const express = require('express');
const mongoose = require('mongoose');
const router = express.Router();

// Define Mongoose Schemas and Models
const orderSchema = new mongoose.Schema({
  bouquetsId: [mongoose.Schema.Types.ObjectId],
  customerUsername: String,
  businessUsername: [String],
  totalPrice: Number,
  time: String,
  status: [String],
});

const itemSchema = new mongoose.Schema({
  name: String,
  flowerType: [String],
  tags: [String],
  imageURL: String,
  description: String,
  business: String,
  color: [String],
  wrapColor: [String],
  price: Number,
  careTips: String,
  rating: Number,
  ratingCount: { type: Number, default: 0 },
});



// Controller for getting total price of items in an order
const getTotalPrice = async (req, res) => {
  const { orderId } = req.params;

  if (!orderId) {
    return res.status(400).json({ error: 'Order ID is required.' });
  }

  try {
    // Find the order by ID
    const order = await Order.findById(orderId);

    if (!order) {
      return res.status(404).json({ error: 'Order not found.' });
    }

    // Fetch item details
    const items = await Item.find({ _id: { $in: order.bouquetsId } });

    // Calculate total prices for each item and the overall total
    const itemPrices = items.map((item) => ({
      itemId: item._id,
      name: item.name,
      price: item.price,
    }));

    const totalPrice = itemPrices.reduce((sum, item) => sum + item.price, 0);

    res.status(200).json({
      message: 'Total prices fetched successfully.',
      items: itemPrices,
      totalPrice: totalPrice
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching total prices.' });
  }
};


module.exports = {updateRatings,getOrderStatusForBusiness, getOrderById,getOrdersByBusiness,getTotalPriceByBusiness,getOrderItemsByBusiness,updateOrderStatus,getOrdersByBusinessAndStatus,DenyOrder,createOrder,getTopBusinesses,getOrderSummary,getOrdersByCustomerUsername,getTotalPrice};