// ignore_for_file: dead_code, prefer_const_constructors, prefer_const_declarations

import 'package:flutter/material.dart';

class PasswordPage extends StatelessWidget {
  const PasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final showForgotPasswordBody = true;

    return showForgotPasswordBody
        ? _ForgotPasswordBody()
        : _ResetPasswordBody();
  }
}

class _ForgotPasswordBody extends StatelessWidget {
  const _ForgotPasswordBody();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _ResetPasswordBody extends StatelessWidget {
  const _ResetPasswordBody();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
