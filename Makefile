WORKDIR ?= $(CURDIR)
BUILD_RUNNER = dart run build_runner build --delete-conflicting-outputs
GEN_FILES = \( -name '*.g.dart' -o -name '*.gr.dart' -o -name '*.config.dart' -o -name '*.auto_mappr.dart' -o -name '*.mocks.dart' \)

# Flutter Build
fb:
	cd "$(WORKDIR)" && flutter pub get && $(BUILD_RUNNER)

# Dart Build Runner
db:
	cd "$(WORKDIR)" && $(BUILD_RUNNER)

# Flutter Rebuild
frb:
	cd "$(WORKDIR)" && flutter clean && find . -type f $(GEN_FILES) -delete && flutter pub get && $(BUILD_RUNNER)

# Clean
clean:
	cd "$(WORKDIR)" && flutter clean && find . -type f $(GEN_FILES) -delete

# Plain Rebuild
mr:
	cd "$(WORKDIR)" && melos rebuild:all

# Analyze (scoped)
# Usage:
# - make analyze WORKDIR=apps/multichoice
# - make analyze WORKDIR=packages/core
analyze:
	cd "$(WORKDIR)" && flutter analyze

analyze_multichoice:
	$(MAKE) analyze WORKDIR=apps/multichoice

analyze_core:
	$(MAKE) analyze WORKDIR=packages/core

analyze_models:
	$(MAKE) analyze WORKDIR=packages/models

analyze_theme:
	$(MAKE) analyze WORKDIR=packages/theme

analyze_ui_kit:
	$(MAKE) analyze WORKDIR=packages/ui_kit

# Enable DebugView for Firebase Analytics
debug_view:
	cd "$(WORKDIR)" && adb shell setprop debug.firebase.analytics.app co.za.zanderkotze.multichoice

# Kill crashed emulator processes
kill_emulator:
	taskkill /F /IM qemu-system-x86_64.exe 2>NUL || taskkill /F /IM emulator.exe 2>NUL || echo "No emulator processes found"

# Launch emulator
launch_emulator:
	flutter emulators --launch Pixel_9_36.1