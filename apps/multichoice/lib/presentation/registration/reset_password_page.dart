import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/registration/widgets/password_field.dart';
import 'package:ui_kit/ui_kit.dart';

/// Duration to show success message on button before navigating.
const _successMessageDuration = Duration(milliseconds: 1000);

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
  String? _successMessage;

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
    setState(() {
      _isLoading = false;
      _successMessage = 'Password reset successfully!';
    });

    await Future<void>.delayed(_successMessageDuration);
    if (!context.mounted) return;
    context.router.popUntilRouteWithName(HomePageWrapperRoute.name);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = _isLoading || _successMessage != null;

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
                  labelText: 'New Password',
                  hintText: 'Enter new password',
                  showRequirements: true,
                ),
                gap16,
                PasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter password',
                  validatePolicy: false,
                  validator: _confirmValidator,
                ),
                gap24,
                AsyncFilledButton(
                  onPressed: () => _onReset(context),
                  isLoading: _isLoading,
                  successLabel: _successMessage,
                  successIcon: _successMessage != null
                      ? Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: colorScheme.onPrimary,
                        )
                      : null,
                  label: const Text('Reset Password'),
                ),
                gap16,
                TextButton(
                  onPressed: isDisabled
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
