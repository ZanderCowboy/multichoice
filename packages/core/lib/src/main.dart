import 'package:core/src/get_it_injection.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureCoreDependencies();
}
