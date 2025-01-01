const { generateGiftCardMessage } = require('../model/giftCardMessage.model');

// Controller function to generate a gift card message
const giftCardMessage = async (req, res) => {
    const { inputText } = req.body; // Extract input text from request body
    try {
        const message = await generateGiftCardMessage(inputText); // Call the model
        res.json({ message }); // Respond with the generated message
    } catch (error) {
        console.error('Error in controller:', error.message);
        res.status(500).json({ error: 'Failed to generate message' });
    }
};

module.exports = { giftCardMessage };
