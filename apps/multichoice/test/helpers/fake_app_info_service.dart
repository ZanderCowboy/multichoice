import 'package:core/core.dart';

class FakeAppInfoService implements IAppInfoService {
  @override
  Future<String> getAppVersion() async => '1.0.0+45';

  @override
  Future<String> getDisplayAppVersion() async => '1.0.0';

  @override
  Future<bool> isUpdateAvailable(String latestVersion) async => false;
}
