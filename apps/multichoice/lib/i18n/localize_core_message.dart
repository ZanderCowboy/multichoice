import 'package:flutter/widgets.dart';
import 'package:multichoice/i18n/strings.g.dart';

/// Maps English error/success strings emitted by [packages/core] to localized
/// copy at the presentation boundary.
String localizeCoreMessage(BuildContext context, String message) {
  return localizeCoreMessageWithTranslations(context.t, message);
}

String localizeCoreMessageWithTranslations(
  Translations translations,
  String message,
) {
  final trimmed = message.trim();
  if (trimmed.isEmpty) return message;

  final errors = translations.errors;
  final validation = translations.validation;

  if (trimmed.startsWith('Password must include: ')) {
    final requirements = trimmed.substring('Password must include: '.length);
    return validation.passwordMustInclude(requirements: requirements);
  }

  return switch (trimmed) {
    /// validation
    'Email is required' => validation.emailRequired,
    'Enter a valid email address' => validation.invalidEmail,
    'Username is required' => validation.usernameRequired,
    'Username must be at least 2 characters' => validation.usernameMinLength,
    'Email or username is required' => validation.emailOrUsernameRequired,
    'Password is required' => validation.passwordRequired,
    'Please confirm your password' => validation.confirmPasswordRequired,
    'Passwords do not match' => validation.passwordsDoNotMatch,

    /// errors
    'Failed to add collection.' => errors.failedToAddCollection,
    'Failed to add item.' => errors.failedToAddItem,
    'Tab entries failed to delete.' => errors.tabEntriesFailedToDelete,
    'Failed to delete all tabs.' => errors.failedToDeleteAllTabs,
    'Password changed successfully!' => errors.passwordChangedSuccessfully,
    'Password reset successfully!' => errors.passwordResetSuccessfully,
    'Please choose a rating from 1 to 5 stars.' => errors.chooseRating,
    'You can submit up to 5 feedback reports per day. Try again tomorrow.' =>
      errors.feedbackDailyLimit,
    "We couldn't send your feedback. Please check your connection and try again." =>
      errors.feedbackSubmitFailed,
    'An account already exists for this email.' => errors.accountAlreadyExists,
    'Invalid email address.' => errors.invalidEmailAddress,
    'Email/password accounts are not enabled.' =>
      errors.emailPasswordNotEnabled,
    'Password is too weak.' => errors.passwordTooWeak,
    'This account has been disabled.' => errors.accountDisabled,
    'No account found for this email.' => errors.noAccountFound,
    'Incorrect password.' => errors.incorrectPassword,
    'Invalid email or password.' => errors.invalidEmailOrPassword,
    'This reset link has expired. Request a new one.' =>
      errors.resetLinkExpired,
    'This reset link is invalid or was already used.' =>
      errors.resetLinkInvalid,
    _ => message,
  };
}
