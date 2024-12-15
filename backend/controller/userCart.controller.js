const cartService = require("../services/userCart.service");
const UserCartModel = require("../model/userCart.model"); // Use the correct path to the model

exports.addItemToCart = async (req, res) => {
  try {
    const { username, itemName, quantity } = req.body;
    await cartService.addItemToCart(username, itemName, quantity);
    res.status(200).json({ message: "Item added to cart successfully." });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.removeItemFromCart = async (req, res) => {
  try {
    const { username, itemName } = req.params;

    const updatedCart = await cartService.removeItemFromCart(
      username,
      itemName
    );

    res.status(200).json({
      message: "Item updated in cart successfully.",
      cart: updatedCart,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getCart = async (req, res) => {
  try {
    const username = req.params.username;
    const cart = await cartService.getCartWithDetails(username);
    res.status(200).json(cart);
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};
