part of '../home_page.dart';

class VerticalTab extends StatelessWidget {
  const VerticalTab({
    required this.tabId,
    required this.tabTitle,
    super.key,
  });

  final int tabId;
  final String tabTitle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          coreSl<HomeBloc>()..add(HomeEvent.onGetEntryCards(tabId)),
      child: GestureDetector(
        onLongPress: () {
          CustomDialog<Widget>.show(
            context: context,
            title: Text('Delete $tabTitle'),
            content: SizedBox(
              height: 20,
              child: Text(
                "Are you sure you want to delete $tabTitle and all it's data?",
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  gap10,
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<HomeBloc>()
                          .add(HomeEvent.onLongPressedDeleteTab(tabId));

                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          );
        },
        child: Card(
          color: Colors.grey[300],
          elevation: 5,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: circularBorder12,
          ),
          child: Padding(
            padding: allPadding6,
            child: SizedBox(
              // TODO(ZanderCowboy): Create a constants file for App Constants
              width: MediaQuery.sizeOf(context).width / 6,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tabTitle,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.minor_crash_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  gap10,
                  Cards(tabId: tabId),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
