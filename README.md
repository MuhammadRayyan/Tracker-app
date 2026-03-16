# Habit Tracker - Android App

A dark-themed, mobile-first habit tracker app built with Capacitor. Track daily habits, view analytics, export/import your data.

## Features

- **Daily tracking** with horizontal day scroller
- **Grid view** — full month overview
- **Stats** — per-habit progress bars, weekly rings, overall %
- **Auto-save** — all data saved to localStorage instantly
- **Export/Import** — JSON backup files for data portability
- **Offline-first** — works without internet
- **Dark theme** — designed for OLED screens

---

## How to Build the APK

### Option A: Build Locally (requires Android Studio)

**Prerequisites:**
- Node.js 18+ → https://nodejs.org
- Java JDK 17+ → https://adoptium.net
- Android Studio → https://developer.android.com/studio
  - After install, open Android Studio and let it download SDK 34

**Steps:**

```bash
# 1. Clone or extract the project
cd habit-tracker

# 2. Run the build script
chmod +x build-apk.sh
./build-apk.sh
```

The APK will be at: `habit-tracker.apk`

**Or manually:**

```bash
npm install
npx cap sync android
cd android
chmod +x gradlew
./gradlew assembleDebug
# APK → android/app/build/outputs/apk/debug/app-debug.apk
```

**Or open in Android Studio:**

```bash
npm install
npx cap sync android
npx cap open android
# Then click ▶ Run in Android Studio
```

---

### Option B: Build in the Cloud (no install needed)

1. Create a GitHub repository and push this project
2. Go to the **Actions** tab → select **Build Android APK**
3. Click **Run workflow**
4. Wait ~3 minutes, then download the APK from **Artifacts**

The workflow file is already included at `.github/workflows/build-apk.yml`.

---

### Option C: Build with Docker (no Android Studio needed)

```bash
# Use a pre-built Android builder image
docker run --rm -v $(pwd):/app -w /app thyrlian/android-sdk:latest bash -c "
  apt-get update && apt-get install -y nodejs npm
  npm install
  npx cap sync android
  cd android && chmod +x gradlew
  ./gradlew assembleDebug
"

# APK → android/app/build/outputs/apk/debug/app-debug.apk
```

---

## Install on Your Phone

1. Transfer `app-debug.apk` to your phone (USB, email, Google Drive, etc.)
2. Open the file on your phone
3. Allow "Install from unknown sources" if prompted
4. Done! The app icon appears on your home screen

---

## Data Backup & Restore

### Before updating the app:
1. Open the app → **Data** tab (💾)
2. Tap **Export Backup** → downloads a `.json` file
3. Save this file somewhere safe

### After reinstalling:
1. Open the app → **Data** tab (💾)
2. Tap **Import Backup** → select your `.json` file
3. Choose **Replace All** or **Merge**

---

## Project Structure

```
habit-tracker/
├── public/              # Web app (the actual UI)
│   ├── index.html       # Complete app in one file
│   ├── manifest.json    # PWA manifest
│   ├── sw.js           # Service worker for offline
│   ├── icon-192.png    # App icon
│   └── icon-512.png    # App icon large
├── android/             # Android project (Capacitor)
│   ├── app/
│   │   └── src/main/
│   │       ├── assets/public/   # Synced web content
│   │       ├── res/             # Android resources & icons
│   │       └── AndroidManifest.xml
│   └── gradlew          # Gradle build tool
├── capacitor.config.ts  # Capacitor config
├── package.json
├── build-apk.sh         # One-click build script
└── .github/workflows/   # GitHub Actions auto-build
```

## Tech Stack

- **UI**: Vanilla HTML/CSS/JS (no framework, fast loading)
- **Wrapper**: Capacitor 6 (web → native Android)
- **Storage**: localStorage (persists in WebView)
- **Theme**: Custom dark OLED theme with warm accents
