# [Add and Implement DB](https://github.com/ZanderCowboy/multichoice/issues/4)

## Ticket: [4](https://github.com/ZanderCowboy/multichoice/issues/4)

### branch: `4-add-and-implement-db`

### Overview

This ticket served for us to implement an [Isar](https://isar.dev/) database for our app.

### What was done

- [X] Restructured `HomePage` to use a single bloc `home_bloc` instead of having an extra bloc `entry_bloc` and added those to `home_bloc`
- [X] Added `InjectableModule` class to set up `Isar` DB
- [X] Code cleanup
- [X] Updated `TabsRepository` and `EntryRepository` for Isar DB
- [X] Updated `Tabs` and `Entry` models with `timestamps` for sequential entries in the DB
- [X] Updated `packageName` for Flutter app
- [X] Updated UI to use `Slivers` instead
- [X] Added `Delete` button to UI and backend to clear DB

### Resources

- [How to Change Package Name in Flutter](https://stackoverflow.com/questions/51534616/how-to-change-package-name-in-flutter)
- [`change_app_package_name`](https://pub.dev/packages/change_app_package_name)
- [How can I change the RAM amount that the Android emulator is using](https://stackoverflow.com/questions/40068344/how-can-i-change-the-ram-amount-that-the-android-emulator-is-using/65685513#65685513)
- [Flutter gradle plugin apply](https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply)
- [Flutter Shader](https://docs.flutter.dev/perf/shader)
- [Gradle build error with NDK version - ndk.dir version which disagrees with android.ndkVersion](https://stackoverflow.com/questions/67604073/gradle-build-error-with-ndk-version-ndk-dir-version-which-disagrees-with-andro)
