part of '../details_page.dart';

class _ResultListTile extends StatelessWidget {
  const _ResultListTile({
    required this.title,
    required this.subtitle,
    this.margin = horizontal12,
    this.internalPadding = allPadding12,
  });

  final String title;
  final String subtitle;
  final EdgeInsets margin;
  final EdgeInsets internalPadding;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular8,
      ),
      margin: margin,
      color: context.appColorsTheme.secondary,
      child: Padding(
        padding: internalPadding,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.appTextTheme.contrastTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  gap4,
                  Text(
                    subtitle,
                    style: context.appTextTheme.contrastSubtitle,
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
