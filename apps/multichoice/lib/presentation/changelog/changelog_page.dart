import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:ui_kit/ui_kit.dart';

part 'utils/_refresh_changelog.dart';
part 'widgets/_changelog_list.dart';
part 'widgets/_failed_changelog.dart';
part 'widgets/_no_changelog.dart';

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
                  return _FailedChangelog(
                    message: state.errorMessage!,
                  );
                }

                final changelog = state.changelog;

                if (changelog == null || changelog.versions.isEmpty) {
                  return const _NoChangelog();
                }

                return _ChangelogList(changelog: changelog);
              },
            ),
          ),
        ),
      ),
    );
  }
}
