import 'package:core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:isar/isar.dart';
import 'package:mockito/annotations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

@GenerateNiceMocks([
  MockSpec<ITabsRepository>(as: #MockTabsRepository),
  MockSpec<IEntryRepository>(as: #MockEntryRepository),
  MockSpec<IDemoRepository>(as: #MockDemoRepository),
  MockSpec<Isar>(as: #MockIsar),
  MockSpec<IFilePickerWrapper>(as: #MockFilePickerWrapper),
  MockSpec<FilePicker>(as: #MockFilePicker),
  MockSpec<PathProviderPlatform>(as: #MockPathProviderPlatform),
  MockSpec<PackageInfo>(as: #MockPackageInfo),
])
void main() {}
