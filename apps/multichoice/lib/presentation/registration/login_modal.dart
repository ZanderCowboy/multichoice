// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multichoice/presentation/registration/login_page.dart';
import 'package:ui_kit/ui_kit.dart';

/// Opens login in an app-styled modal.
void showLoginModal(BuildContext context) {
  unawaited(
    Future<void>.microtask(
      () => CustomDialog<AlertDialog>.show(
        context: context,
        title: const Text('Sign In'),
        content: const LoginPage(isModal: true),
      ),
    ),
  );
}
