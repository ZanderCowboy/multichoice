# Wrappers

## What exactly is a Wrapper?

A wrapper is a lightweight abstraction (usually an interface or abstract class) around a specific dependency or third-party library. It exposes only the methods your app needs, without leaking implementation details.

## Why should one use a Wrapper?

Wrappers are useful for the following reasons:
1. Decoupling your code from third-party dependencies.
2. Make testing easier, possibly a main benefit.
3. It allows one to simplify your architecture, by providing a clear layer between your business logic and external dependencies.
4. It also improved flexibility by encouraging dependency injection.

## When should one use a Wrapper?

Here’s how you identify a prime spot for using wrappers:
- Using third-party packages that are complex, likely to change, or difficult to test.
- Whenever a dependency uses platform channels or native code.
- If you anticipate possibly replacing or changing a dependency later.
- If you want your codebase to be easily unit testable.

## Possible downsides to using a Wrapper

- Using wrappers can add a slight complexity to your code, i.e. an extra class or interface.
- It can also be redundant if not used correctly.

**Key: Use wrappers strategically when clear value emerges (testability, decoupling, flexibility).**

## Practical Example

```dart
abstract class FilePickerWrapper {
  Future<String?> saveFile({required String dialogTitle, required String fileName, Uint8List? bytes});
}

class FilePickerWrapperImpl implements FilePickerWrapper {
  @override
  Future<String?> saveFile(...) {
    return FilePicker.platform.saveFile(...);
  }
}

```
Usage:
```dart
class DataExchangeService {
  final FilePickerWrapper filePickerWrapper;

  DataExchangeService(this.filePickerWrapper);

  Future<void> saveFile(...) {
    await filePickerWrapper.saveFile(...);
  }
}
```
