part of '../changelog_page.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({required this.outerContext});

  final BuildContext outerContext;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
            onPressed: () => _refreshChangelog(outerContext),
          ),
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            context.router.popUntilRoot();
            scaffoldKey.currentState?.closeDrawer();
          },
        ),
      ],
    );
  }
}
