const Order = require('../model/order.model');
const Item = require('../model/item.model');

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

  
module.exports = { getOrdersByBusiness,getTotalPriceByBusiness,getOrderItemsByBusiness,updateOrderStatus,getOrdersByBusinessAndStatus,DenyOrder};