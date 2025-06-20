from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
import cv2
import os
from tensorflow.keras.models import load_model

app = Flask(__name__)
CORS(app)

# Define model path relative to working directory
MODEL_PATH = os.path.join(os.getcwd(), 'assets', 'checkpoint_enhanced_fine.keras')

# Check and load model
if os.path.exists(MODEL_PATH):
    print(f"[✔] Model file found at: {MODEL_PATH}")
    model = load_model(MODEL_PATH)
else:
    print(f"[✖] Model file NOT found at: {MODEL_PATH}")
    raise FileNotFoundError(f"Model file not found at {MODEL_PATH}")

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400

    try:
        file = request.files['image']
        img = cv2.imdecode(np.frombuffer(file.read(), np.uint8), cv2.IMREAD_COLOR)
        img = cv2.resize(img, (224, 224))
        img = np.expand_dims(img, axis=0) / 255.0
        pred = model.predict(img)
        result = 'Malignant' if pred[0][1] > 0.5 else 'Benign'
        return jsonify({'prediction': result})
    except Exception as e:
        print(f"[!] Prediction error: {str(e)}")
        return jsonify({'error': 'Failed to process image'}), 500

if __name__ == '__main__':
    print("[🚀] Starting server on port 5000")
    app.run(debug=True, host='0.0.0.0', port=5000)