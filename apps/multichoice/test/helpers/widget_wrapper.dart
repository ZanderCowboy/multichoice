import 'package:flutter/material.dart';

Widget widgetWrapper({required Widget child}) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}
