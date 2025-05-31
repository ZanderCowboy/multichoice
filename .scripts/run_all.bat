@echo off
setlocal

:: Call the startup-test script to run the tests and capture emulator info
call run_integration_test.bat %*

:: Call the shutdown script to close the emulator
call run_shutdown_emulator.bat

endlocal
exit /b
