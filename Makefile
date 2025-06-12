# Flutter Build
fb: 
	flutter pub get && dart run build_runner build --delete-conflicting-outputs

# Dart Build Runner
db:
	dart run build_runner build --delete-conflicting-outputs

# Flutter Rebuild
frb:
	flutter clean && find * -type f \( -name '*.g.dart' -o -name '*.gr.dart' -o -name '*.freezed.dart' -o -name '*.config.dart' -o -name '*.auto_mappr.dart' -o -name '*.mocks.dart' \) -delete && flutter pub get && dart run build_runner build --delete-conflicting-outputs

# Clean
clean:
	flutter clean && find * -type f \( -name '*.g.dart' -o -name '*.gr.dart' -o -name '*.freezed.dart' -o -name '*.config.dart' -o -name '*.auto_mappr.dart' -o -name '*.mocks.dart' \) -delete

# Plain Rebuild
mr:
	melos rebuild:all