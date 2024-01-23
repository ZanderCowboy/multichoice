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
  final String? tabId;
  final String? entryId;

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
        // height: 60,
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
                    Text(tabId ?? ''),
                    gap4,
                    Text(entryId ?? ''),
                  ],
                ),
              ),
              const Placeholder(
                fallbackHeight: 40,
                fallbackWidth: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
