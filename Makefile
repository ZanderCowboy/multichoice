fb:
	flutter pub get && dart run build_runner build --delete-conflicting-outputs
	
db:
	dart run build_runner build --delete-conflicting-outputs

frb:
	flutter clean && find * -type f \( -name '*.g.dart' -o -name '*.gr.dart' -o -name '*.freezed.dart' -o -name '*.config.dart' -o -name '*.auto_mappr.dart' -o -name '*.mocks.dart' \) -delete && flutter pub get && dart run build_runner build --delete-conflicting-outputs

clean:
	flutter clean && find * -type f \( -name '*.g.dart' -o -name '*.gr.dart' -o -name '*.freezed.dart' -o -name '*.config.dart' -o -name '*.auto_mappr.dart' -o -name '*.mocks.dart' \) -delete