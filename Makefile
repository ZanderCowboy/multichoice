fb:
	flutter pub get && dart run build_runner build --delete-conflicting-outputs
	
db:
	dart run build_runner build --delete-conflicting-outputs

clean:
	flutter clean && find * -type f \( -name '*.g.dart' -o -name '*.gr.dart' -o -name '*.freezed.dart' -o -name '*.config.dart' -o -name '*.auto_mappr.dart' -o -name '*.mocks.dart' \) -delete

# rebuild:
	# flutter clean 
	# find * -type f \( \
	# 	-name '*.g.dart' -o \
	# 	-name '*.gr.dart' -o \
	# 	-name '*.freezed.dart' -o \
	# 	-name '*.config.dart' -o \
	# 	-name '*.auto_mappr.dart' -o \
	# 	-name '*.mocks.dart' \
	# \) -delete

	# flutter pub get
	# dart run build_runner build --delete-conflicting-outputs

# rebuild:
# 	flutter clean
# 	for /r %i in (*.g.dart *.gr.dart *.freezed.dart *.config.dart *.auto_mappr.dart *.mocks.dart) do del %i
# 	flutter pub get
# 	dart run build_runner build --delete-conflicting-outputs

clean_build:
    echo off
    call clean_build.bat