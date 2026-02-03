import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:isar_community/isar.dart';
import 'package:mockito/annotations.dart';
import 'package:models/models.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([
  MockSpec<ITabsRepository>(as: #MockTabsRepository),
  MockSpec<IEntryRepository>(as: #MockEntryRepository),
  MockSpec<ITutorialRepository>(as: #MockTutorialRepository),
  MockSpec<Isar>(as: #MockIsar),
  MockSpec<IsarCollection<Tabs>>(as: #MockIsarCollection),
  MockSpec<IsarCollection<Entry>>(as: #MockIsarCollectionEntry),
  MockSpec<IFilePickerWrapper>(as: #MockFilePickerWrapper),
  MockSpec<FilePicker>(as: #MockFilePicker),
  MockSpec<PathProviderPlatform>(as: #MockPathProviderPlatform),
  MockSpec<PackageInfo>(as: #MockPackageInfo),
  MockSpec<IProductTourController>(as: #MockProductTourController),
  MockSpec<SharedPreferences>(as: #MockSharedPreferences),
  MockSpec<IAppStorageService>(as: #MockAppStorageService),
  MockSpec<IFeedbackRepository>(as: #MockFeedbackRepository),
  MockSpec<FirebaseFirestore>(as: #MockFirebaseFirestore),
  MockSpec<CollectionReference<Map<String, dynamic>>>(
    as: #MockCollectionReference,
  ),
  MockSpec<QuerySnapshot<Map<String, dynamic>>>(as: #MockQuerySnapshot),
  MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>(
    as: #MockQueryDocumentSnapshot,
  ),
  MockSpec<DocumentReference<Map<String, dynamic>>>(as: #MockDocumentReference),
  MockSpec<ISearchRepository>(as: #MockSearchRepository),
])
void main() {}
