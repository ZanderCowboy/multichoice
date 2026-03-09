part of '../changelog_page.dart';

Future<void> _refreshChangelog(BuildContext context) async {
  try {
    // Force refresh Firebase Remote Config immediately (bypasses minimumFetchInterval)
    final firebaseService = coreSl<IFirebaseService>();
    await firebaseService.forceFetchAndActivate();

    // Trigger changelog refetch
    if (context.mounted) {
      context.read<ChangelogBloc>().add(const ChangelogEvent.fetch());
    }
    // ignore: avoid_catches_without_on_clauses
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
