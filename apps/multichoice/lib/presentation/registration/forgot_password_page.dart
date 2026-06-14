// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/registration/widgets/email_field.dart';
import 'package:multichoice/utils/user_accounts_feature.dart';
import 'package:open_mail/open_mail.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    super.key,
    this.prePopulatedEmail,
  });

  final String? prePopulatedEmail;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  /// Duration to show success message on button before switching to check email.
  static const _successMessageDuration = Duration(milliseconds: 1000);
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _emailSent = false;
  String? _successMessage;
  bool _emailValid = false;

  @override
  void initState() {
    super.initState();
    guardUserAccountsRoute(context);
    if (widget.prePopulatedEmail != null &&
        widget.prePopulatedEmail!.isNotEmpty) {
      _emailController.text = widget.prePopulatedEmail!;
    }
    _emailController.addListener(_syncEmailValidity);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncEmailValidity());
  }

  @override
  void dispose() {
    _emailController
      ..removeListener(_syncEmailValidity)
      ..dispose();
    super.dispose();
  }

  void _syncEmailValidity() {
    if (!mounted) return;
    final email = _emailController.text.trim();
    final ok = email.isNotEmpty && EmailField.defaultValidator(email, context.t) == null;
    if (ok != _emailValid) {
      setState(() => _emailValid = ok);
    }
  }

  Future<void> _onResetPassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final result = await coreSl<IRegistrationRepository>()
        .sendPasswordResetEmail(email);

    if (!context.mounted) return;

    var sent = false;
    result.fold(
      (err) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.message)),
        );
      },
      (_) {
        sent = true;
        setState(() {
          _isLoading = false;
          _successMessage = context.t.auth.resetLinkSent;
        });
      },
    );

    if (!sent || !context.mounted) return;
    await Future<void>.delayed(_successMessageDuration);
    if (!context.mounted) return;
    setState(() {
      _successMessage = null;
      _emailSent = true;
    });
  }

  void _onGoToResetPage(BuildContext context) {
    unawaited(context.router.push(ResetPasswordPageRoute()));
  }

  Future<void> _openEmailApp(BuildContext context) async {
    final apps = await OpenMail.getMailApps();

    if (apps.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t.auth.noEmailAppsFound),
        ),
      );
      return;
    }

    if (apps.length == 1) {
      final result = await OpenMail.openMailApp();
      if (!result.didOpen && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t.auth.couldNotOpenEmailApp)),
        );
      }
      return;
    }

    // Show picker when multiple email apps are available
    final selectedApp = await showDialog<MailApp>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.t.auth.openEmailApp),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.t.auth.chooseEmailAppPrompt,
            ),
            gap16,
            SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: apps.length,
                itemBuilder: (ctx, index) {
                  final app = apps[index];
                  return ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(app.name),
                    onTap: () => Navigator.of(ctx).pop(app),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.t.common.cancel),
          ),
        ],
      ),
    );

    if (selectedApp != null) {
      await OpenMail.openSpecificMailApp(selectedApp.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.auth.forgotPassword),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SafeArea(
        child: _emailSent
            ? _buildCheckEmailContent(context)
            : _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: allPadding16,
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              gap24,
              Text(
                context.t.auth.resetPasswordInstructions,
                style: context.appTextTheme.bodyLarge,
              ),
              gap24,
              EmailField(controller: _emailController),
              gap24,
              AsyncFilledButton(
                onPressed: () => _onResetPassword(context),
                enabled: _emailValid,
                isLoading: _isLoading,
                successLabel: _successMessage,
                flexSuccessLabel: true,
                successIcon: _successMessage != null
                    ? Icon(
                        Icons.check_circle_outline,
                        size: 20,
                        color: context.appColorsTheme.primary,
                      )
                    : null,
                label: Text(context.t.auth.sendResetLink),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckEmailContent(BuildContext context) {
    return Padding(
      padding: allPadding16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          gap24,
          const Icon(
            Icons.mark_email_read_outlined,
            size: 64,
          ),
          gap24,
          Text(
            context.t.auth.checkYourEmail,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          gap12,
          Text(
            context.t.auth.passwordResetSentDescription(
              email: _emailController.text,
            ),
            style: context.appTextTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          gap24,
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _openEmailApp(context),
              icon: const Icon(Icons.open_in_new),
              label: Text(context.t.auth.openEmailApp),
            ),
          ),
          gap12,
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _onGoToResetPage(context),
              child: Text(context.t.auth.goToResetPassword),
            ),
          ),
          gap16,
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: Text(context.t.auth.backToSignIn),
          ),
        ],
      ),
    );
  }
}
