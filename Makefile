fb:
	flutter pub get && dart run build_runner build --delete-conflicting-outputs
	
db:
	dart run build_runner build --delete-conflicting-outputs

frb:
	flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs