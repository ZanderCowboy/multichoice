@echo on
rem Perform flutter clean
flutter clean

rem Delete generated .g.dart files
for /r %%i in (*.g.dart) do (
    del "%%i"
)

rem Run flutter pub get
flutter pub get

rem Run dart build_runner
flutter pub run build_runner build --delete-conflicting-outputs

rem Optional: Pause to see output before closing
pause