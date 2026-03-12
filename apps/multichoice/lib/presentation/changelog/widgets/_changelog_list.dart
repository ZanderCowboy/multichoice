part of '../changelog_page.dart';

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
