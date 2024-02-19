part of '../home_page.dart';

class VerticalTab extends HookWidget {
  const VerticalTab({
    required this.tabId,
    required this.tabTitle,
    super.key,
  });

  final int tabId;
  final String tabTitle;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState<bool>(false);
    final isInMenu = useState<bool>(false);

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
          child: MouseRegion(
            onEnter: (_) => isHovered.value = true,
            onExit: (_) {
              if (!isInMenu.value) {
                isHovered.value = false;
              }
            },
            child: Padding(
              padding: allPadding6,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width / 4,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 6,
                      ),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                tabTitle,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            if (Platform.isAndroid || Platform.isIOS)
                              MenuWidget(
                                tabId: tabId,
                              )
                            else
                              const SizedBox.shrink(),
                            if (isHovered.value)
                              MenuWidget(
                                tabId: tabId,
                                onOpen: () => isInMenu.value = true,
                                onClose: () => isInMenu.value = false,
                              )
                            else
                              const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                    gap10,
                    Cards(tabId: tabId),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
