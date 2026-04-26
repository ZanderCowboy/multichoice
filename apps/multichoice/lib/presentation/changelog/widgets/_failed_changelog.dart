part of '../changelog_page.dart';

class _FailedChangelog extends StatelessWidget {
  const _FailedChangelog({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
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
              message,
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
