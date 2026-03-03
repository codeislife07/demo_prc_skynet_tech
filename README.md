# Practical Test Flutter App

## Basic Introduction

This app is built for a Flutter practical task and supports Android, iOS, and Web.

Main modules:
- Auth: Login and Register using local SQLite
- Session: Auto-login with saved session
- Home: Product list from API
- Details: Product detail view with sticky image header
- Responsive UI: Works across phone/tablet/web screen sizes

## API Used

- `https://tropicalfruitandveg.com/api/tfvjsonapi.php?search=all`

## Tech Stack

- Flutter
- flutter_bloc
- sqflite / sqflite_common_ffi / sqflite_common_ffi_web
- shared_preferences
- http

## Setup

```bash
flutter pub get
```

For web (required):

```bash
dart run sqflite_common_ffi_web:setup
```

Run app:

```bash
flutter run
```

Run on web:

```bash
flutter run -d chrome
```

## Build Commands

```bash
flutter build apk
flutter build ios
flutter build web
```

## Video Demo (OS Based)

### Android

Record screen:

```bash
adb shell screenrecord /sdcard/demo.mp4
```

After demo, stop recording (Ctrl + C), then pull file:

```bash
adb pull /sdcard/demo.mp4 .
```

### iOS (Simulator)

- Open iOS Simulator
- Menu: `File -> Record Screen`
- Start/stop recording and save video

### Web

- Run app in Chrome
- Use browser screen recorder extension or OBS
- Record flow: Login/Register -> Home -> Details -> Logout

## Notes

- Social login icons are UI-only (no social auth integration).
- If web SQLite fails, rerun:

```bash
dart run sqflite_common_ffi_web:setup
```
