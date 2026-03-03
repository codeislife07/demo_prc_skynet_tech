# Practical Test App

Simple Flutter app for practical task.

## What this app does

- Login and Register with local SQLite
- Maintain user session
- Show product list from API
- Show product details
- Responsive UI for Android, iOS, and Web

## API

`https://tropicalfruitandveg.com/api/tfvjsonapi.php?search=all`

## Requirements

- Flutter SDK
- Dart SDK

## Setup

1. Install dependencies:

```bash
flutter pub get
```

2. For web, setup SQLite binaries:

```bash
dart run sqflite_common_ffi_web:setup
```

3. Run app:

```bash
flutter run
```

4. Run on web:

```bash
flutter run -d chrome
```

## Build

```bash
flutter build apk
flutter build ios
flutter build web
```
