part of '../home_page.dart';

class VerticalTab extends StatelessWidget {
  const VerticalTab({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Card(
      elevation: 5,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width / 6,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text(title)),
                  const IconButton(
                    onPressed: null,
                    icon: Icon(Icons.add_outlined),
                  ),
                ],
              ),
              gap_10,
              Expanded(
                child: ScrollConfiguration(
                  behavior: CustomScrollBehaviour(),
                  child: ListView(
                    controller: scrollController,
                    children: const [
                      EntryCard(),
                      gap_16,
                      EntryCard(),
                      gap_16,
                      EntryCard(),
                      gap_16,
                      EntryCard(),
                      gap_16,
                      EntryCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}