@echo off
setlocal

:: Read the emulator state from the temporary file
for /f "tokens=2 delims==" %%i in ('findstr "EMULATOR_STARTED" emulator_state.txt') do set EMULATOR_STARTED=%%i
for /f "tokens=2 delims==" %%i in ('findstr "EMULATOR_DEVICE" emulator_state.txt') do set EMULATOR_DEVICE=%%i

:: Check if an emulator was started by the script
:: Check if any emulators are connected
for /f "tokens=1" %%i in ('adb devices ^| findstr /i "emulator"') do (
    echo Closing emulator %%i...
    adb -s %%i emu kill
)

:: Check if the script started an emulator
if "%EMULATOR_STARTED%"=="1" (
    echo Also closing the emulator %EMULATOR_DEVICE% started by this script...
    adb -s %EMULATOR_DEVICE% emu kill
) else (
    echo No emulator explicitly started by this script.
)


:: Clean up the state file
del emulator_state.txt

endlocal
exit /b
