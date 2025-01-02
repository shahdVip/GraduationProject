const UserCartModel = require("../model/userCart.model"); // Use the correct path to the model
const ItemsModel = require("../model/item.model"); // Adjust the path
const addItemToCart = async (req, res) => {
  try {
    const { username, itemId } = req.body;

    // Validate inputs
    if (!username || !itemId) {
      return res.status(400).json({ message: "Username and Item ID are required" });
    }

    // Find the cart by username
    let userCart = await UserCartModel.findOne({ username });

    // If no cart exists, create a new one
    if (!userCart) {
      userCart = new UserCartModel({ username, itemsId: [] });
    }

    // Add the item to the cart (even if it already exists)
    userCart.itemsId.push(itemId);

    // Save the cart
    await userCart.save();

    res.status(200).json({ message: "Item added successfully", cart: userCart });
  } catch (error) {
    console.error("Error adding item to cart:", error.message);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};




const removeItemByIndex = async (req, res) => {
  try {
    const { username, index } = req.params; // Extract from path parameters

    // Validate inputs
    if (!username || index === undefined) {
      return res.status(400).json({ message: "Username and index are required" });
    }

    // Find the user"s cart
    const userCart = await UserCartModel.findOne({ username });
    if (!userCart) {
      return res.status(404).json({ message: "Cart not found" });
    }

    // Validate index
    const itemIndex = parseInt(index, 10);
    if (isNaN(itemIndex) || itemIndex < 0 || itemIndex >= userCart.itemsId.length) {
      return res.status(400).json({ message: "Invalid index" });
    }

    // Remove the item from the array
    userCart.itemsId.splice(itemIndex, 1);

    // Save the updated cart
    await userCart.save();

    res.status(200).json({
      message: "Item removed successfully",
      cart: userCart,
    });
  } catch (error) {
    console.error("Error removing item:", error);
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};



  const getCart = async (req, res) => {
    const { username } = req.params;
  
    try {
      // Step 1: Find the user"s cart by username
      const userCart = await UserCartModel.findOne({ username });
      if (!userCart) {
        return res.status(404).json({ message: "User cart not found" });
      }
  
      // Step 2: Fetch all items by their IDs, preserving duplicates
      const itemMap = await ItemsModel.find({ _id: { $in: userCart.itemsId } })
        .then(items => items.reduce((map, item) => {
          map[item._id.toString()] = item;
          return map;
        }, {}));
  
      // Step 3: Map itemsId to their corresponding items, including duplicates
      const itemsWithDuplicates = userCart.itemsId.map(itemId => itemMap[itemId]);
  
      // Step 4: Return the full list of items
      res.status(200).json(itemsWithDuplicates);
    } catch (error) {
      console.error("Error fetching user cart:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };
  

  module.exports = { getCart,removeItemByIndex,addItemToCart };