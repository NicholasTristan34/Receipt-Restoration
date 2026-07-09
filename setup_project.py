#!/usr/bin/env python3
"""
Setup script for Receipt Restoration iOS App
This script configures the Xcode project automatically
"""

import os
import sys
import subprocess
import re

def main():
    print("Receipt Restoration iOS App - Setup Script")
    print("=" * 50)

    # Check if we're in the right directory
    if not os.path.exists("ReceiptRestoration.xcodeproj"):
        os.chdir("ReceiptRestoration")
        if not os.path.exists("ReceiptRestoration.xcodeproj"):
            print("❌ Error: Could not find ReceiptRestoration.xcodeproj")
            print("   Please run this script from the project root directory")
            sys.exit(1)

    # Check for required files
    print("\n📋 Checking required files...")

    files_to_check = {
        "receipt_restoration.onnx": "ONNX model file",
        "ReceiptRestoration/ReceiptRestorationApp.swift": "App entry point",
        "ReceiptRestoration/ContentView.swift": "Main UI",
        "ReceiptRestoration/ReceiptRestorationModel.swift": "Model handler",
        "ReceiptRestoration/ImageProcessor.swift": "Image processor",
        "ReceiptRestoration/ComparisonSliderView.swift": "Comparison view",
        "ReceiptRestoration/ImagePicker.swift": "Image picker",
    }

    all_files_present = True
    for file, description in files_to_check.items():
        if os.path.exists(file):
            print(f"   ✓ {description}: {file}")
        else:
            print(f"   ✗ {description}: {file} [MISSING]")
            all_files_present = False

    if not all_files_present:
        print("\n❌ Some required files are missing!")
        sys.exit(1)

    print("\n✅ All required files are present!")

    # Instructions for manual steps
    print("\n" + "=" * 50)
    print("📝 MANUAL SETUP STEPS REQUIRED")
    print("=" * 50)

    print("\n1️⃣  OPEN THE PROJECT IN XCODE:")
    print("    • Open 'ReceiptRestoration.xcodeproj' in Xcode")

    print("\n2️⃣  ADD ONNX RUNTIME PACKAGE:")
    print("    • Select the project in Project Navigator")
    print("    • Select 'ReceiptRestoration' target")
    print("    • Go to 'General' tab")
    print("    • Scroll to 'Frameworks, Libraries, and Embedded Content'")
    print("    • Click '+' button")
    print("    • Select 'Add Package Dependency...'")
    print("    • Enter URL: https://github.com/microsoft/onnxruntime-swift-package-manager")
    print("    • Click 'Add Package'")
    print("    • Select 'onnxruntime' (NOT onnxruntime_extensions) and click 'Add Package'")
    print("    • Note: Package product is 'onnxruntime', but code imports 'onnxruntime_objc'")

    print("\n3️⃣  ADD ONNX MODEL TO PROJECT:")
    print("    • Right-click 'ReceiptRestoration' folder in Project Navigator")
    print("    • Select 'Add Files to ReceiptRestoration...'")
    print("    • Select 'receipt_restoration.onnx'")
    print("    • Check 'Copy items if needed'")
    print("    • Check 'Add to targets: ReceiptRestoration'")
    print("    • Click 'Add'")

    print("\n4️⃣  BUILD AND RUN:")
    print("    • Select a simulator or device")
    print("    • Click Run (▶) or press Cmd+R")

    print("\n" + "=" * 50)
    print("📚 For detailed instructions, see: SETUP_INSTRUCTIONS.md")
    print("=" * 50)

    # Offer to open the project
    print("\n❓ Would you like to open the project in Xcode now? (y/n): ", end="")
    try:
        response = input().strip().lower()
        if response == 'y':
            print("\n🚀 Opening project in Xcode...")
            subprocess.run(["open", "ReceiptRestoration.xcodeproj"])
            print("✅ Project opened! Follow the manual steps above.")
        else:
            print("\n👋 Setup script complete. Open the project manually when ready.")
    except KeyboardInterrupt:
        print("\n\n👋 Setup script cancelled.")
        sys.exit(0)

if __name__ == "__main__":
    main()
