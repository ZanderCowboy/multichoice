import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/registration/widgets/password_field.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _confirmValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _onReset(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Mock success - replace with backend call later
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!context.mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset successfully!')),
    );
    context.router.popUntilRouteWithName(LoginPageRoute.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: allPadding16,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                gap24,
                PasswordField(
                  controller: _newPasswordController,
                  customLabel: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.password,
                        color: context.appColorsTheme.iconColor,
                      ),
                      gap4,
                      Text(
                        'New Password',
                        style: TextStyle(
                          color: context
                              .theme
                              .inputDecorationTheme
                              .labelStyle
                              ?.color,
                        ),
                      ),
                    ],
                  ),
                  hintText: 'Enter new password',
                  showRequirements: true,
                ),
                gap16,
                PasswordField(
                  controller: _confirmPasswordController,
                  customLabel: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.password,
                        color: context.appColorsTheme.iconColor,
                      ),
                      gap4,
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                          color: context
                              .theme
                              .inputDecorationTheme
                              .labelStyle
                              ?.color,
                        ),
                      ),
                    ],
                  ),
                  hintText: 'Re-enter password',
                  validatePolicy: false,
                  validator: _confirmValidator,
                ),
                gap24,
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : () => _onReset(context),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Reset Password'),
                  ),
                ),
                gap16,
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => context.router.popUntilRouteWithName(
                          LoginPageRoute.name,
                        ),
                  child: const Text('Back to Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
