import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/theme/app_typography.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ChangelogPage extends StatelessWidget {
  const ChangelogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => coreSl<ChangelogBloc>()..add(const ChangelogEvent.fetch()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Changelog'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => context.router.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                context.router.popUntilRoot();
                scaffoldKey.currentState?.closeDrawer();
              },
            ),
          ],
        ),
        body: BlocBuilder<ChangelogBloc, ChangelogState>(
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
                      const Text(
                        'Failed to load changelog',
                        style: AppTypography.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      gap8,
                      Text(
                        state.errorMessage!,
                        style: AppTypography.bodySmall,
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
                      const Text(
                        'No changelog available',
                        style: AppTypography.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      gap8,
                      const Text(
                        'Check back later for updates',
                        style: AppTypography.bodySmall,
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
    );
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
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          gap4,
                          Text(
                            changelogEntry.date,
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white70,
                            ),
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
                          style: AppTypography.bodyMedium.copyWith(
                            color: context.theme.appColors.ternary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            change,
                            style: AppTypography.bodyMedium,
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
