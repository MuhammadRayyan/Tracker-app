#!/bin/bash
set -e

echo "========================================"
echo "  Habit Tracker - Android APK Builder"
echo "========================================"
echo ""

# Check prerequisites
command -v java >/dev/null 2>&1 || { echo "ERROR: Java not found. Install JDK 17+."; exit 1; }
command -v node >/dev/null 2>&1 || { echo "ERROR: Node.js not found. Install Node 18+."; exit 1; }

# Check ANDROID_HOME
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
  # Try common paths
  if [ -d "$HOME/Android/Sdk" ]; then
    export ANDROID_HOME="$HOME/Android/Sdk"
  elif [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
  elif [ -d "/usr/local/lib/android/sdk" ]; then
    export ANDROID_HOME="/usr/local/lib/android/sdk"
  else
    echo "ERROR: Android SDK not found. Set ANDROID_HOME or install Android Studio."
    echo "  Download: https://developer.android.com/studio"
    exit 1
  fi
fi

SDK="${ANDROID_HOME:-$ANDROID_SDK_ROOT}"
echo "Using Android SDK: $SDK"
echo "Using Java: $(java -version 2>&1 | head -1)"
echo "Using Node: $(node -v)"
echo ""

# Step 1: Install dependencies
echo "[1/4] Installing dependencies..."
npm install --silent

# Step 2: Sync web assets
echo "[2/4] Syncing web assets to Android..."
npx cap sync android

# Step 3: Build APK
echo "[3/4] Building debug APK..."
cd android
chmod +x gradlew
./gradlew assembleDebug --warning-mode=none

# Step 4: Show result
APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK_PATH" ]; then
  SIZE=$(du -h "$APK_PATH" | cut -f1)
  echo ""
  echo "========================================"
  echo "  BUILD SUCCESSFUL!"
  echo "========================================"
  echo ""
  echo "  APK: android/$APK_PATH"
  echo "  Size: $SIZE"
  echo ""
  echo "  To install on your phone:"
  echo "  1. Connect your phone via USB"
  echo "  2. Enable USB debugging in Developer Settings"
  echo "  3. Run: adb install $APK_PATH"
  echo "  Or: Transfer the APK file to your phone and open it"
  echo ""
  
  # Copy to project root for convenience
  cp "$APK_PATH" "../habit-tracker.apk"
  echo "  Also copied to: habit-tracker.apk"
  echo ""
else
  echo "ERROR: APK not found at expected path."
  echo "Check the Gradle output above for errors."
  exit 1
fi
