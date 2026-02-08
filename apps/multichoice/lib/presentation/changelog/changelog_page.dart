// ignore_for_file: avoid_catches_without_on_clauses, document_ignores

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ChangelogPage extends StatelessWidget {
  const ChangelogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => coreSl<ChangelogBloc>()..add(const ChangelogEvent.fetch()),
      child: Builder(
        builder: (blocContext) => Scaffold(
          appBar: AppBar(
            title: const Text('Changelog'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () => context.router.pop(),
            ),
            actions: [
              if (kDebugMode)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh Remote Config',
                  onPressed: () => _refreshChangelog(blocContext),
                ),
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  context.router.popUntilRoot();
                  scaffoldKey.currentState?.closeDrawer();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: BlocBuilder<ChangelogBloc, ChangelogState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularLoader.medium());
                }

                if (state.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: allPadding24,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color:
                                context.theme.appColors.error ??
                                Theme.of(context).colorScheme.error,
                          ),
                          gap16,
                          Text(
                            'Failed to load changelog',
                            style:
                                context.theme.appTextTheme.titleMedium ??
                                Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          gap8,
                          Text(
                            state.errorMessage!,
                            style:
                                context.theme.appTextTheme.bodySmall ??
                                Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final changelog = state.changelog;

                if (changelog == null || changelog.versions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: allPadding24,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 64,
                            color: context.theme.appColors.ternary,
                          ),
                          gap16,
                          Text(
                            'No changelog available',
                            style:
                                context.theme.appTextTheme.titleMedium ??
                                Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          gap8,
                          Text(
                            'Check back later for updates',
                            style:
                                context.theme.appTextTheme.bodySmall ??
                                Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return _ChangelogList(changelog: changelog);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshChangelog(BuildContext context) async {
    try {
      // Force refresh Firebase Remote Config immediately (bypasses minimumFetchInterval)
      final firebaseService = coreSl<IFirebaseService>();
      await firebaseService.forceFetchAndActivate();

      // Trigger changelog refetch
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
}

class _ChangelogList extends StatelessWidget {
  const _ChangelogList({required this.changelog});

  final Changelog changelog;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: allPadding16,
      itemCount: changelog.versions.length,
      itemBuilder: (context, index) {
        final entry = changelog.versions.entries.elementAt(index);
        final version = entry.key;
        final changelogEntry = entry.value;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: borderCircular12,
          ),
          margin: bottom12,
          color: context.theme.appColors.primary,
          child: Padding(
            padding: allPadding16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Version $version',
                            style:
                                context.theme.appTextTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ) ??
                                Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          gap4,
                          Text(
                            changelogEntry.date,
                            style:
                                context.theme.appTextTheme.bodySmall ??
                                Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                gap12,
                ...changelogEntry.changes.map(
                  (change) => Padding(
                    padding: left12 + top4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style:
                              context.theme.appTextTheme.bodyMedium?.copyWith(
                                color: context.theme.appColors.ternary,
                                fontWeight: FontWeight.bold,
                              ) ??
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: context.theme.appColors.ternary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            change,
                            style:
                                context.theme.appTextTheme.bodyMedium?.copyWith(
                                  color: context.theme.appColors.ternary,
                                ) ??
                                Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: context.theme.appColors.ternary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
