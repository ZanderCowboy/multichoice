# Integration Testing

## How to run integration tests

- Run `apps\multichoice\integration_test\app_test.dart`
- Command for running workflows locally
```sh
act -W .github\workflows\_build-android-app.yml --use-new-action-cache --privileged --insecure-secrets --container-architecture linux/amd64
```

## Setup

- In `pubspec.yaml`, ensure that all the required dependencies are present
```dart
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```
- Create a `integration_test` folder with `app_test.dart` as the main test file
- In `app_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_flutter_project/main.dart'; // Import your app entry point

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("App initializes correctly", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());  // Load the app

    expect(find.text("Welcome"), findsOneWidget);  // Verify a widget appears
  });
}
```
- Run the tests with
```sh
flutter test integration_test/
```

## Resources

<https://chatgpt.com/c/67cc7fc9-6160-8004-b255-7e6eea74dc51>
