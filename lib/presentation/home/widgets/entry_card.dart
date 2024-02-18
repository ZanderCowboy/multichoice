part of '../home_page.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({
    required this.title,
    required this.subtitle,
    this.tabId,
    this.entryId,
    super.key,
  });

  final int? tabId;
  final int? entryId;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: circularBorder5,
      ),
      color: const Color.fromARGB(255, 81, 153, 187),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: allPadding4,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      title ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
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
