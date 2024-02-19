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
    return Card(
      elevation: 5,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: circularBorder5,
      ),
      color: Colors.blueGrey,
      child: SizedBox(
        width: 200,
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
              // const Placeholder(
              //   fallbackHeight: 40,
              //   fallbackWidth: 40,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
