part of '../details_page.dart';

class _ResultListTile extends StatelessWidget {
  const _ResultListTile({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.grey[400],
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular8,
      ),
      margin: zeroPadding,
      color: context.theme.appColors.secondary,
      child: Padding(
        padding: allPadding12,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 16,
                          letterSpacing: 0.3,
                          height: 1,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  gap4,
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          letterSpacing: 0.5,
                          height: 1.25,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
