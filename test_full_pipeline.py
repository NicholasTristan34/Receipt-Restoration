"""
Test the full OCR pipeline: Detection -> Crop -> Recognition
This shows the correct workflow that should be in your Swift app
"""

import onnxruntime as ort
import numpy as np
from PIL import Image, ImageDraw
import cv2

def preprocess_detection(img, target_size=640):
    """Preprocess image for detection model"""
    # Resize to 640x640
    img_resized = img.resize((target_size, target_size), Image.BILINEAR)
    img_array = np.array(img_resized).astype(np.float32)

    # Convert RGB to BGR
    img_array = img_array[:, :, ::-1]

    # Normalize to [-1, 1]
    img_array = img_array / 255.0
    img_array = (img_array - 0.5) / 0.5

    # Convert to NCHW format [1, 3, 640, 640]
    img_array = np.transpose(img_array, (2, 0, 1))
    img_array = np.expand_dims(img_array, axis=0)

    return img_array

def preprocess_recognition(img, target_height=48):
    """Preprocess cropped text region for recognition"""
    aspect_ratio = img.width / img.height
    target_width = int(target_height * aspect_ratio)
    target_width = min(max(target_width, 10), 320)

    img_resized = img.resize((target_width, target_height), Image.BILINEAR)
    img_array = np.array(img_resized).astype(np.float32)

    # Convert RGB to BGR
    img_array = img_array[:, :, ::-1]

    # Normalize to [-1, 1]
    img_array = img_array / 255.0
    img_array = (img_array - 0.5) / 0.5

    # Convert to NCHW format [1, 3, 48, W]
    img_array = np.transpose(img_array, (2, 0, 1))
    img_array = np.expand_dims(img_array, axis=0)

    return img_array

def detect_text_regions(det_session, img):
    """Run detection model and get text regions"""
    # Preprocess
    input_array = preprocess_detection(img, 640)

    # Run detection
    outputs = det_session.run(None, {"x": input_array})
    prob_map = outputs[0]  # Shape: [1, 1, H, W]

    print(f"Detection output shape: {prob_map.shape}")
    print(f"Probability range: [{prob_map.min():.3f}, {prob_map.max():.3f}]")

    # Squeeze to [H, W]
    prob_map = prob_map.squeeze()

    # Threshold to get binary mask
    threshold = 0.3
    binary_mask = (prob_map > threshold).astype(np.uint8) * 255

    # Find contours
    contours, _ = cv2.findContours(binary_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    print(f"Found {len(contours)} text regions")

    # Get bounding boxes
    boxes = []
    for contour in contours:
        x, y, w, h = cv2.boundingRect(contour)
        if w > 10 and h > 5:  # Filter small regions
            boxes.append((x, y, w, h))

    return boxes, prob_map

def recognize_text(rec_session, img, characters):
    """Run recognition on a cropped text region"""
    # Preprocess
    input_array = preprocess_recognition(img, 48)

    print(f"Recognition input shape: {input_array.shape}")
    print(f"Recognition input range: [{input_array.min():.3f}, {input_array.max():.3f}]")

    # Run recognition
    outputs = rec_session.run(None, {"x": input_array})
    output = outputs[0]  # Shape: [1, seq_len, num_classes]

    print(f"Recognition output shape: {output.shape}")

    # Decode
    num_classes = output.shape[2]
    seq_length = output.shape[1]

    result = []
    last_idx = -1
    for t in range(seq_length):
        max_idx = np.argmax(output[0, t, :])
        max_val = output[0, t, max_idx]

        if max_idx != 0 and max_idx != last_idx:
            char_idx = max_idx - 1
            if 0 <= char_idx < len(characters):
                result.append(characters[char_idx])
        last_idx = max_idx

    return ''.join(result)

# Main pipeline
if __name__ == "__main__":
    # Load models
    det_session = ort.InferenceSession("det_model.onnx")
    rec_session = ort.InferenceSession("rec_model.onnx")

    # Load character dictionary
    with open("en_dict.txt", "r", encoding="utf-8") as f:
        characters = f.read().strip()
    print(f"Loaded {len(characters)} characters")

    # Load image
    img_path = input("Enter path to test image: ")
    img = Image.open(img_path).convert("RGB")
    print(f"Image size: {img.size}")

    # Step 1: Detect text regions
    print("\n=== STEP 1: DETECTION ===")
    boxes, prob_map = detect_text_regions(det_session, img)

    # Calculate scale factor (detection was done on 640x640)
    scale_x = img.width / 640
    scale_y = img.height / 640

    # Step 2 & 3: Crop and recognize each region
    print("\n=== STEP 2 & 3: CROP & RECOGNIZE ===")
    results = []
    for i, (x, y, w, h) in enumerate(boxes):
        # Scale box back to original image coordinates
        x_orig = int(x * scale_x)
        y_orig = int(y * scale_y)
        w_orig = int(w * scale_x)
        h_orig = int(h * scale_y)

        # Crop text region from ORIGINAL image (not resized)
        cropped = img.crop((x_orig, y_orig, x_orig + w_orig, y_orig + h_orig))

        print(f"\nRegion {i+1}: Box=({x_orig}, {y_orig}, {w_orig}, {h_orig}), Crop size={cropped.size}")

        # Save cropped region for inspection
        cropped.save(f"crop_{i+1}.jpg")

        # Recognize text
        text = recognize_text(rec_session, cropped, characters)
        results.append({
            'box': (x_orig, y_orig, w_orig, h_orig),
            'text': text
        })

        print(f"Recognized: '{text}'")

    # Draw results
    draw_img = img.copy()
    draw = ImageDraw.Draw(draw_img)
    for i, result in enumerate(results):
        x, y, w, h = result['box']
        draw.rectangle([x, y, x+w, y+h], outline='red', width=2)
        draw.text((x, y-15), result['text'], fill='red')

    draw_img.save("detection_result.jpg")
    print(f"\n=== COMPLETE ===")
    print(f"Found {len(results)} text regions")
    print("Saved: detection_result.jpg and crop_*.jpg")
    for i, result in enumerate(results):
        print(f"  {i+1}. '{result['text']}'")
