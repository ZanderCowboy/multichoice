@echo off
setlocal enabledelayedexpansion

set EMULATOR_DEVICE=""
set EMULATOR_STARTED=0

:: Check if an emulator name is passed as a parameter
if "%1"=="" (
    echo No emulator name provided, listing available emulators...

    :: List available emulators, filter out unnecessary info
    set EMULATOR_COUNT=0
    for /f "tokens=1" %%i in ('emulator -list-avds 2^>nul ^| findstr /v "INFO"') do (
        set /a EMULATOR_COUNT+=1
        echo [!EMULATOR_COUNT!] %%i
        set EMULATOR_NAME_%%EMULATOR_COUNT%%=%%i
    )

    :: Check if any emulators were found
    if !EMULATOR_COUNT! equ 0 (
        echo No emulators found.
        exit /b 1
    )

    :: Prompt the user to select an emulator
    set /p EMULATOR_CHOICE="Enter the number of the emulator you want to use: "

    :: Validate the choice
    if !EMULATOR_CHOICE! lss 1 (
        echo Invalid selection.
        exit /b 1
    )
    if !EMULATOR_CHOICE! gtr !EMULATOR_COUNT! (
        echo Invalid selection.
        exit /b 1
    )

    for /L %%i in (1,1,%EMULATOR_COUNT%) do (
        if "!EMULATOR_CHOICE!"=="%%i" (
            set EMULATOR_NAME=!EMULATOR_NAME_%%i!
        )
    )
    echo Emulator selected: !EMULATOR_NAME!

    if "!EMULATOR_NAME!"=="" (
        echo Invalid selection.
        exit /b 1
    )
) else (
    :: Use the provided emulator name
    set EMULATOR_NAME=%1
)

:: Check if an Android device or emulator is already connected by filtering out desktop devices
set ANDROID_DEVICE_FOUND=0
for /f "tokens=*" %%i in ('flutter devices ^| findstr /i "android" /i "mobile") do (
    echo %%i
    set ANDROID_DEVICE_FOUND=1
)

echo Android device or emulator found: !ANDROID_DEVICE_FOUND!

:: If no Android emulator or device is found, start the selected emulator
if !ANDROID_DEVICE_FOUND! equ 0 (
    echo No Android emulators or devices found. Starting emulator: !EMULATOR_NAME!...
    start "" emulator -avd !EMULATOR_NAME!
    set EMULATOR_STARTED=1
    echo Waiting for the emulator to start...
    
    :: Wait for the emulator to boot up
    adb wait-for-device
) else (
    echo Android device or emulator is already connected.
)

:: Check again to ensure the Android device or emulator is ready
set ANDROID_DEVICE_READY=0
for /f "tokens=*" %%i in ('adb devices ^| findstr /i "device"') do (
    set ANDROID_DEVICE_READY=1
)

if !ANDROID_DEVICE_READY! equ 0 (
    echo No Android emulator or device found, exiting...
    exit /b 1
)

:: Debugging info - print emulator startup status
echo Emulator started: !EMULATOR_STARTED!
echo Emulator device: !EMULATOR_NAME!

:: Save emulator state to a temporary file for the shutdown script to use
(
    echo EMULATOR_STARTED=!EMULATOR_STARTED!
    echo EMULATOR_DEVICE=!EMULATOR_NAME!
) > tmp/emulator_state.txt

:: Debugging: Ensure the file was written by printing its contents
echo Emulator state saved to file:
type tmp/emulator_state.txt

:: Change directory to apps/multichoice
cd apps/multichoice

:: Run the Flutter integration test
echo Running Flutter integration test...
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart

:: Return to the original directory
cd ../../

endlocal
exit /b
