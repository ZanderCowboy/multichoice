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