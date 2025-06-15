import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class FakePathProviderPlatform extends PathProviderPlatform {
  FakePathProviderPlatform() : super();

  @override
  Future<String> getApplicationDocumentsPath() async {
    return "/mocked/path";
  }
}
