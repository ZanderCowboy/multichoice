part of '../home_page.dart';

class VerticalTab extends StatelessWidget {
  const VerticalTab({
    required this.tabId,
    required this.tabTitle,
    super.key,
  });

  final String tabId;
  final String tabTitle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Card(
          elevation: 5,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: circularBorder12,
          ),
          child: Padding(
            padding: allPadding6,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width / 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(tabTitle)),
                      const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.minor_crash_rounded),
                      ),
                    ],
                  ),
                  gap10,
                  Cards(tabId: tabId),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
