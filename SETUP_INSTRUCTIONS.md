# Receipt Restoration iOS App - Setup Instructions

This guide will help you set up and run the Receipt Restoration iOS app.

## Prerequisites

- Xcode 15.0 or later
- iOS 16.1 or later (target device or simulator)
- The ONNX model file: `receipt_restoration.onnx`

## Setup Steps

### 1. Open the Project in Xcode

1. Navigate to the project directory
2. Open `ReceiptRestoration/ReceiptRestoration.xcodeproj` in Xcode

### 2. Add ONNX Runtime Package

1. In Xcode, select the project in the navigator (blue icon)
2. Select the "ReceiptRestoration" target
3. Go to the "General" tab
4. Scroll down to "Frameworks, Libraries, and Embedded Content"
5. Click the "+" button
6. Select "Add Package Dependency..."
7. Enter the following URL: `https://github.com/microsoft/onnxruntime-swift-package-manager`
8. Click "Add Package"
9. Select **"onnxruntime"** (NOT onnxruntime_extensions) and click "Add Package"

**Note:** The package product is called "onnxruntime", but the module to import in code is `onnxruntime_objc`.

### 3. Add the ONNX Model to the Project

The model file is already in the project directory at `ReceiptRestoration/receipt_restoration.onnx`. You need to add it to the Xcode project:

1. In Xcode's Project Navigator (left sidebar), right-click on the "ReceiptRestoration" folder (yellow icon)
2. Select "Add Files to 'ReceiptRestoration'..."
3. Navigate to and select `receipt_restoration.onnx`
4. Make sure "Copy items if needed" is checked
5. Make sure "Add to targets: ReceiptRestoration" is checked
6. Click "Add"

### 4. Build and Run

1. Select a simulator or connected device
2. Click the "Run" button (▶) or press Cmd+R
3. The app should build and launch

## Usage

### Taking or Selecting a Photo

1. Tap "Photo Library" to select an existing receipt image
2. Or tap "Camera" to take a new photo of a receipt

### Restoring the Receipt

1. After selecting an image, tap "Restore Receipt"
2. Wait for the AI model to process the image (may take a few seconds)
3. The restored image will appear next to the original

### Comparing Before/After

1. Once restoration is complete, use the segmented control to switch between:
   - "Side by Side" - View both images side by side
   - "Comparison" - Interactive slider to compare images

### Saving the Result

1. Tap "Save to Photos" to save the restored image to your photo library
2. The first time you do this, iOS will ask for permission

### Clearing Images

1. Tap "Clear" to remove both images and start over

## Troubleshooting

### Build Errors

**"No such module 'onnxruntime_objc'"**
- Make sure you've added the ONNX Runtime package (Step 2)
- Make sure you selected "onnxruntime" package product (the module to import is `onnxruntime_objc`)
- Clean build folder: Product > Clean Build Folder (Shift+Cmd+K)
- Try restarting Xcode
- Verify the package appears in Project Navigator under "Package Dependencies"

**"Could not find receipt_restoration.onnx in bundle"**
- Make sure the model file is added to the project target (Step 3)
- Check that the file appears in the "Copy Bundle Resources" build phase

### Runtime Errors

**Camera/Photos permission denied**
- Go to Settings > Privacy & Security > Camera/Photos and enable permissions for the app
- The app will automatically request permissions on first use

**Model inference fails**
- Check that the ONNX model file is correctly formatted
- Verify the model input/output dimensions match (512x512, RGB, NCHW format)

## Project Structure

```
ReceiptRestoration/
├── ReceiptRestorationApp.swift    # App entry point
├── ContentView.swift               # Main UI
├── ReceiptRestorationModel.swift  # ONNX model handler
├── ImageProcessor.swift           # Image preprocessing/postprocessing
├── ComparisonSliderView.swift     # Before/after comparison UI
├── ImagePicker.swift              # Photo picker wrapper
└── receipt_restoration.onnx       # AI model (permissions in build settings)
```

## Model Specifications

- **Input**: 512×512 RGB image, NCHW format, normalized to [0, 1]
- **Output**: 512×512 RGB image, NCHW format, values in [0, 1]
- **Processing**: Automatic resize with padding, aspect ratio preserved

## Support

For issues or questions, please check:
1. All files are properly added to the Xcode project
2. ONNX Runtime package is correctly installed
3. Deployment target is set correctly
4. Info.plist permissions are configured
