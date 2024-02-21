part of '../home_page.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({
    required this.title,
    required this.subtitle,
    this.tabId,
    this.entryId,
    super.key,
  });

  final String title;
  final String subtitle;
  final int? tabId;
  final int? entryId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: allPadding2,
      child: Card(
        margin: EdgeInsets.zero,
        color: context.theme.appColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: borderCircular5,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: allPadding4,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(title),
                      Text(subtitle),
                      Text('t-id: $tabId'),
                      gap4,
                      Text('e-id: $entryId'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
