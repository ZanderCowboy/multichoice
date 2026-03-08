part of '../changelog_page.dart';

class _NoChangelog extends StatelessWidget {
  const _NoChangelog();

  @override
  Widget build(BuildContext context) {
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
}
