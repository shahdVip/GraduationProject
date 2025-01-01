from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
import torch
import json
import random
from difflib import get_close_matches

# Load the fine-tuned model and tokenizer
model = AutoModelForCausalLM.from_pretrained("./fine_tuned_model")
tokenizer = AutoTokenizer.from_pretrained("./fine_tuned_model")
print("Fine-tuned GPT-2 model loaded!")

# Ensure pad token is set
if tokenizer.pad_token is None:
    tokenizer.pad_token = tokenizer.eos_token

# Device configuration
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model.to(device)
print(f"Device set to use {device.type}")

# Initialize sentiment analysis pipeline
sentiment_analyzer = pipeline("sentiment-analysis")

# Load the dataset
with open("data.json", "r") as f:
    dataset = json.load(f)

def get_guided_prompt(input_text):
    """
    Retrieve a guided prompt from the dataset based on similarity.
    """
    inputs_list = [entry["Input"] for entry in dataset]
    closest_match = get_close_matches(input_text.lower(), inputs_list, n=1, cutoff=0.5)
    if closest_match:
        matched_input = closest_match[0]
        for entry in dataset:
            if entry["Input"].lower() == matched_input.lower():
                return random.choice(entry["Outputs"])
    return None  # If no close match is found, return None

def generate_gift_card_message(input_text):
    """
    Generate a meaningful gift card message based on the input statement.
    """
    # Step 1: Detect sentiment of the input
    sentiment_result = sentiment_analyzer(input_text)[0]
    sentiment_label = sentiment_result["label"].lower()  # e.g., "positive", "neutral", "negative"
    print(f"Detected Sentiment: {sentiment_label.upper()}")

    # Step 2: Retrieve a guided prompt from the dataset (if available)
    guided_prompt = get_guided_prompt(input_text)

    # Step 3: Use the model to generate a gift card message
    if guided_prompt:
        prompt = f"Improve this message to make it heartfelt and meaningful: {guided_prompt}"
    else:
        if sentiment_label == "positive":
            prompt = f"Write a heartfelt and beautiful gift card message for a positive sentiment: {input_text}"
        elif sentiment_label == "neutral":
            prompt = f"Write a thoughtful and meaningful gift card message for a neutral sentiment: {input_text}"
        elif sentiment_label == "negative":
            prompt = f"Write an encouraging and uplifting gift card message for a negative sentiment: {input_text}"
        else:
            prompt = f"Write a meaningful gift card message: {input_text}"

    inputs = tokenizer.encode(prompt, return_tensors="pt").to(device)
    outputs = model.generate(
        inputs,
        max_length=100,  # Maximum length of the generated text
        num_return_sequences=1,  # Generate one response
        temperature=0.7,  # Control randomness
        top_k=50,  # Consider only the top-k tokens
        top_p=0.9,  # Nucleus sampling for flexibility
        do_sample=True  # Enable sampling for diverse outputs
    )

    # Decode the generated message
    generated_message = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return generated_message

# Testing the model
inputs = [
    "I love you",
    "Congratulations on your success",
    "Happy Birthday!",
    "Well done",
    "Congratulations on your new house",
]

for i, input_text in enumerate(inputs, 1):
    print(f"\nInput {i}: {input_text}")
    generated_message = generate_gift_card_message(input_text)
    print(f"Generated Gift Card Message for Input {i}: {generated_message}")
