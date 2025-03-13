# [Wrtie Unit Tests](https://github.com/ZanderCowboy/multichoice/issues/14)

## Coverage

As of now, the test coverage is at 90.3%.

## Setting up and Writing unit tests

- <https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters>

## Setting up LCOV in Windows

- In an elevated terminal, use `choco install lcov` to install lcov
- Go to `"C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml"` and add as System environment variable as `GENHTML`
- Install Strawberry Perl with <https://strawberryperl.com/>
- Add `perl` to PATH
- Open a new terminal in VS Code
- Change into directory where `coverage` folder lies
- Run `perl $env:GENHTML -o coverage\html coverage\lcov.info`
- In the same directory, use `start coverage\html\index.html` to open HTML file in a browser

### Running Tests on Windows

There is a `melos` command that can be used to get test coverage and open the report.
```bash
melos coverage:core:windows
```

## Dealing with Issues when Generating Code

### Unregistered Dependencies

```dart
| Missing dependencies in core/src/get_it_injection.dart
|
| [TabsRepository] depends on unregistered type [Clock] from package:clock/clock.dart
| [FilePickerWrapper] depends on unregistered type [FilePicker] from package:file_picker/file_picker.dart
|
| Did you forget to annotate the above class(s) or their implementation with @injectable?
| or add the right environment keys?
```

**Solution:**

- Remove `Clock` and `FilePicker` LazySingletons in `configureCoreDependencies`
- Add `@lazySingleton` for FilePicker.platform instance to `InjectableModule`

### FlutterGen Issue

```dart
ERROR: ERROR: [FlutterGen] Specified build.yaml as input but the file does not contain valid options, ignoring...
```

**Solution:**

In `apps/multichoice`:
- Add `build.yaml` file with builders for the `flutter_gen_runner`
- Update `output: lib/generated/` in `pubspec.yaml`
- Update `.gitignore` for new `generated` folder
