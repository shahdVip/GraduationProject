const axios = require('axios');

// Function to call the Python Flask service
const generateGiftCardMessage = async (inputText) => {
    try {
        const response = await axios.post('http://127.0.0.1:5000/generate', {
            input_text: inputText,
        });
        return response.data.message; // Return the generated message from Flask
    } catch (error) {
        console.error('Error in model:', error.message);
        throw new Error('Failed to communicate with Python service');
    }
};

module.exports = { generateGiftCardMessage };
