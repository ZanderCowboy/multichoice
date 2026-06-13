// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/registration/login_page.dart';
import 'package:multichoice/utils/user_accounts_feature.dart';
import 'package:ui_kit/ui_kit.dart';

/// Opens login in an app-styled modal.
void showLoginModal(BuildContext context) {
  if (!isUserAccountsEnabled()) return;

  unawaited(
    Future<void>.microtask(
      () => CustomDialog<AlertDialog>.show(
        context: context,
        title: Text(context.t.auth.signIn),
        content: const LoginPage(isModal: true),
      ),
    ),
  );
}
