# Flutter Integration Test Automation on Windows (for Android)

This guide explains how to:

* Set up Flutter integration testing for a mobile app.
* Automatically detect whether an Android emulator is running.
* Start an emulator if none is running.
* Run integration tests using `flutter drive`.
* Avoid launching desktop/web devices like Chrome, Edge, or Windows.

---

## How to run integration tests

- Run `apps/multichoice/integration_test/app_test.dart`

## 1. Prerequisites

* Flutter SDK installed and properly configured.
* Android Studio installed with at least one virtual device (AVD) created.
* Java installed (used by Android tools).
* A Flutter app with `integration_test` and `test_driver` folders set up.
* Windows system with access to Command Prompt or PowerShell.

---

## 2. File & Folder Structure

Ensure the following paths exist in your project:

* `apps/multichoice/test_driver/integration_test.dart`
* `apps/multichoice/integration_test/app_test.dart`

These are required by your integration test.

---

## 3. Custom Batch Script: `run_integration_test.bat`

This script:

* Checks for connected Android devices/emulators.
* Ignores non-mobile devices (like Chrome or Windows).
* Starts the first available emulator if none is running.
* Runs the `flutter drive` test command for integration.

Place the following script in your project root as `run_integration_test.bat`:

```batch
@echo off

:: Check if an Android device or emulator is running
flutter devices | findstr /C:"No devices" >nul
if %errorlevel%==0 (
    echo No devices found. Starting emulator...

    :: Get the first available Android emulator
    for /f "tokens=*" %%i in ('emulator -list-avds') do (
        set EMULATOR_NAME=%%i
        goto :start_emulator
    )

    echo No emulator found. Please create one in Android Studio.
    exit /b 1

    :start_emulator
    echo Starting emulator %EMULATOR_NAME%...
    start emulator -avd %EMULATOR_NAME%

    :: Wait for it to be fully online
    echo Waiting for emulator to start...
    adb wait-for-device
) else (
    :: Check if a mobile (Android) device is connected
    flutter devices | findstr /C:"android" >nul
    if %errorlevel%==1 (
        echo No Android devices or emulators found. Starting an emulator...

        for /f "tokens=*" %%i in ('emulator -list-avds') do (
            set EMULATOR_NAME=%%i
            goto :start_emulator
        )

        echo No emulator found. Please create one in Android Studio.
        exit /b 1
    ) else (
        echo Android device or emulator already connected.
    )
)

:: Run integration test
echo Running Flutter integration test...
flutter drive --driver=apps/multichoice/test_driver/integration_test.dart --target=apps/multichoice/integration_test/app_test.dart
```

---

## 4. Add Android Emulator to System PATH

### Problem

If you get the error:

```text
'emulator' is not recognized as an internal or external command,
operable program or batch file.
```

### Solution

Add the following paths to your Windows system PATH:

* `C:\Users\YourUsername\AppData\Local\Android\Sdk\emulator`
* `C:\Users\YourUsername\AppData\Local\Android\Sdk\platform-tools`

### Steps

1. Open Control Panel → System → Advanced system settings → Environment Variables.
2. Under System Variables, select `Path` → Edit → Add the above directories.
3. Restart your terminal.

### Verify

* Run `emulator -list-avds` to see available emulators.
* Run `adb devices` to confirm devices are connected.

---

## 5. Usage

Open Command Prompt or PowerShell and run:

```batch
run_integration_test.bat
```

It will:

* Detect running Android devices or emulators.
* Start one if needed.
* Run your `flutter drive` integration test.

---

## 6. Gotchas

* Emulator must exist (create one via Android Studio → Tools → AVD Manager).
* If only Chrome, Edge, or Windows devices are detected, they will be ignored.
* Emulators may take time to boot up on first launch.
* Integration tests must be run using `flutter drive`, not `flutter run`.
* This script assumes Android-only testing (not desktop/web).

---

## 7. Optional: VS Code Integration

You can run the batch script from a VS Code launch configuration using `preLaunchTask`. Ask for setup details if needed.
