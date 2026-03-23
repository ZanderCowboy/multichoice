import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:file_picker/file_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:models/models.dart' show EntrySchema, TabsSchema;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class InjectableModule {
  @preResolve
  Future<Isar> get isar async {
    final directory = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        TabsSchema,
        EntrySchema,
      ],
      directory: directory.path,
      name: 'MultichoiceDB',
    );

    return isar;
  }

  @preResolve
  Future<SharedPreferences> get sharedPref async {
    final sharedPref = await SharedPreferences.getInstance();

    return sharedPref;
  }

  @lazySingleton
  FilePicker get filePicker => FilePicker.platform;

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn(
        scopes: const ['email', 'profile'],
      );
}
