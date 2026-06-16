import 'package:flutter/material.dart';
import 'package:multichoice/i18n/strings.g.dart';

Widget widgetWrapper({required Widget child}) {
  return TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}
