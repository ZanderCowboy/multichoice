// Template for creating a new page
// Copy this file and replace <PageName> with your actual page name

import 'package:flutter/material.dart';

class <PageName>Page extends StatelessWidget {
  const <PageName>Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('<Page Title>'),
      ),
      body: _<PageName>Page(),
    );
  }
}

class _<PageName>Page extends StatelessWidget {
  const _<PageName>Page();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
