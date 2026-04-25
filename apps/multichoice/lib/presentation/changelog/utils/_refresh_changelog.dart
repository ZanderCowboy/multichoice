// ignore_for_file: avoid_catches_without_on_clauses

part of '../changelog_page.dart';

Future<void> _refreshChangelog(BuildContext context) async {
  try {
    final firebaseService = coreSl<IFirebaseService>();
    await firebaseService.forceFetchAndActivate();

    if (context.mounted) {
      context.read<ChangelogBloc>().add(const ChangelogEvent.fetch());
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
