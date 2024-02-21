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
          color: context.theme.appColors.primary,
          child: Padding(
            padding: vertical8horizontal4,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width / 3,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: onlyLeft4,
                          child: Text(
                            tabTitle,
                            style: context.theme.appTextTheme.titleMedium,
                          ),
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.centerRight,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        onPressed: null,
                        icon: const Icon(
                          Icons.minor_crash_rounded,
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
