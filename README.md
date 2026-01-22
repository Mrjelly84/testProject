# testproject

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

for help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Quick Start

- Install Flutter and verify:

```bash
flutter --version
```

- Get dependencies and run on your target:

```bash
flutter pub get
# Run on Windows desktop
flutter run -d windows
# Run on Android (device/emulator)
flutter run
# Run on web (Chrome)
flutter run -d chrome
```

# Run Instructions

This document explains how to run the Flutter project locally and where the app calls the backend API.

## Prerequisites
- Install Flutter (stable channel). Verify with:

```bash
flutter --version
```

- Android SDK (for Android builds/emulators) or Visual Studio with Desktop development (for Windows desktop).
- For web: a Chrome/Edge browser.

## Setup
1. Fetch Dart/Flutter packages:

```bash
flutter pub get
```

2. (Optional) Enable desktop support on your development machine:

```bash
flutter config --enable-windows-desktop
flutter config --enable-linux-desktop
flutter config --enable-macos-desktop
```

3. Confirm devices:

```bash
flutter devices
```

## Configure backend API
The app calls your backend via the client implemented in `lib/api/database_api.dart`.
Open [lib/api/database_api.dart](lib/api/database_api.dart) and set the API base URL (for example `https://api.example.com` or `http://localhost:3000`).

Notes:
- When running an Android emulator against a backend on your host machine, use `10.0.2.2` (Android emulator) instead of `localhost`.
- Desktop apps (Windows/Linux/macOS) can use `http://localhost:3000` directly.

If you prefer environment-based configuration, I can update `lib/api/database_api.dart` to read from `--dart-define` or a `.env` file.

## Running the app
- Run on Windows desktop:

```bash
flutter run -d windows
```

- Run on Android emulator or device:

```bash
flutter run -d <device-id>
# or
flutter run
```

- Run on web (Chrome):

```bash
flutter run -d chrome
```

## Build release artifacts
- Android APK:

```bash
flutter build apk --release
```

- Windows executable:

```bash
flutter build windows --release
```

- Web:

```bash
flutter build web --release
```

## Tests & analysis
- Run unit/widget tests:

```bash
flutter test
```

- Static analysis:

```bash
flutter analyze
```

## Troubleshooting
- If the app cannot reach the backend from an Android emulator, use `10.0.2.2` for host IP.
- Check token/auth issues in `lib/api/database_api.dart` where `login()` and token storage are implemented.