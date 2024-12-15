const UserCartModel = require("../model/userCart.model"); // Use the correct path to the model
exports.addItemToCart = async (username, itemName, quantity) => {
  const cart = await UserCartModel.findOne({ username });

  if (cart) {
    // Update quantity if item already exists
    const itemIndex = cart.items.findIndex(
      (item) => item.itemName === itemName
    );

    if (itemIndex > -1) {
      cart.items[itemIndex].quantity += quantity;
    } else {
      // Add new item
      cart.items.push({ itemName, quantity });
    }

    await cart.save();
  } else {
    // Create new cart for the user
    const newCart = new UserCartModel({
      username,
      items: [{ itemName, quantity }],
    });
    await newCart.save();
  }
};
exports.removeItemFromCart = async (username, itemName) => {
  const cart = await UserCartModel.findOne({ username });

  if (!cart) {
    throw new Error("Cart not found.");
  }

  // Find the item to remove or decrement
  const itemIndex = cart.items.findIndex((item) => item.itemName === itemName);

  if (itemIndex === -1) {
    throw new Error("Item not found in cart.");
  }

  if (cart.items[itemIndex].quantity > 1) {
    // Reduce the quantity if it's more than 1
    cart.items[itemIndex].quantity -= 1;
  } else {
    // Remove the item if the quantity is 1
    cart.items.splice(itemIndex, 1);
  }

  await cart.save();
  return cart;
};

const ItemModel = require("../model/item.model"); // Assuming you have an items collection

exports.getCartWithDetails = async (username) => {
  const cart = await UserCartModel.findOne({ username });
  if (!cart) {
    throw new Error("Cart not found for the user.");
  }

  // Fetch additional details for items
  const detailedItems = await Promise.all(
    cart.items.map(async ({ itemName, quantity }) => {
      const itemDetails = await ItemModel.findOne({ name: itemName });
      if (!itemDetails) {
        throw new Error(`Item details not found for ${itemName}`);
      }
      return {
        name: itemDetails.name,
        price: itemDetails.price,
        photo: itemDetails.imageURL,
        quantity,
      };
    })
  );

  return { username: cart.username, items: detailedItems };
};
