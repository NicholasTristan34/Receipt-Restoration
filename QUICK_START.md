# Quick Start Guide

## ⚡ Fast Setup (5 minutes)

### Step 1: Run the Setup Script
```bash
cd ReceiptRestoration
python3 ../setup_project.py
```

Or open the project directly:
```bash
open ReceiptRestoration/ReceiptRestoration.xcodeproj
```

### Step 2: Add ONNX Runtime (In Xcode)

1. Click on the project (blue icon) → Select "ReceiptRestoration" target
2. Click the **+** under "Frameworks, Libraries, and Embedded Content"
3. Select "Add Package Dependency..."
4. Paste: `https://github.com/microsoft/onnxruntime-swift-package-manager`
5. Click "Add Package" → Select **"onnxruntime"** (NOT onnxruntime_extensions) → Click "Add Package"

💡 **Note:** Package product is "onnxruntime", but code imports `onnxruntime_objc`

### Step 3: Add Model File (In Xcode)

1. Right-click "ReceiptRestoration" folder (yellow) in Project Navigator
2. Select "Add Files to 'ReceiptRestoration'..."
3. Select `receipt_restoration.onnx`
4. ✅ Check "Copy items if needed"
5. ✅ Check "Add to targets: ReceiptRestoration"
6. Click "Add"

### Step 4: Build & Run

1. Select iPhone simulator
2. Click ▶ (or press ⌘R)
3. Done! 🎉

## 🎯 App Features

- 📸 **Photo Library** - Select receipt images
- 📷 **Camera** - Capture new receipts
- ✨ **Restore** - AI-powered receipt restoration
- 🔀 **Comparison** - Interactive before/after slider
- 💾 **Save** - Save to Photos library
- 🗑️ **Clear** - Reset and start over

## 📁 Project Files

```
ReceiptRestoration/
├── QUICK_START.md                 ← You are here
├── SETUP_INSTRUCTIONS.md          ← Detailed guide
├── setup_project.py               ← Setup automation
└── ReceiptRestoration/
    ├── ReceiptRestoration.xcodeproj
    ├── receipt_restoration.onnx   ← AI model (92MB)
    └── ReceiptRestoration/
        ├── ReceiptRestorationApp.swift
        ├── ContentView.swift
        ├── ReceiptRestorationModel.swift
        ├── ImageProcessor.swift
        ├── ComparisonSliderView.swift
        └── ImagePicker.swift
```

## ❓ Troubleshooting

**Build Error: "No such module 'onnxruntime_objc'"**
→ Complete Step 2 (Add ONNX Runtime package)
→ Make sure you selected "onnxruntime" package product
→ Clean build: Product → Clean Build Folder (Shift+Cmd+K)

**Runtime Error: "Could not find receipt_restoration.onnx"**
→ Complete Step 3 (Add model file to project)

**Permission Error: "Camera/Photos access denied"**
→ Go to Settings → Privacy & Security → Camera/Photos → Enable for app
→ App will request permissions automatically on first use

## 📚 More Help

- Detailed setup: See `SETUP_INSTRUCTIONS.md`
- Model specs: Input/Output 512×512, RGB, [0,1] normalized
- iOS version: Minimum 16.1 recommended

---

**Ready to test?** Select a receipt image and tap "Restore Receipt"!
