import 'package:core/src/services/interfaces/i_app_info_service.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

@LazySingleton(as: IAppInfoService)
class AppInfoService implements IAppInfoService {
  @override
  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = Version.parse(packageInfo.version);
    return '${version.major}.${version.minor}.${version.patch}+${packageInfo.buildNumber}';
  }
}
