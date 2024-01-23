part of '../home_page.dart';

class VerticalTab extends HookWidget {
  const VerticalTab({
    required this.tabId,
    required this.tabTitle,
    super.key,
  });

  final String tabId;
  final String tabTitle;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState<bool>(false);
    final isInMenu = useState<bool>(false);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Card(
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
                            Expanded(child: Text(tabTitle)),
                            isHovered.value
                                ? MenuAnchor(
                                    anchorTapClosesMenu: true,
                                    builder: (
                                      context,
                                      MenuController controller,
                                      Widget? child,
                                    ) {
                                      return IconButton(
                                        onPressed: () {
                                          if (controller.isOpen) {
                                            controller.close();
                                          } else {
                                            controller.open();
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.more_vert_outlined),
                                        hoverColor: Colors.pink,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                      );
                                    },
                                    onOpen: () => isInMenu.value = true,
                                    onClose: () => isInMenu.value = false,
                                    menuChildren: [
                                      ..._getTabsMenuItems(context)
                                          .map((menuItem) {
                                        return MenuItemButton(
                                          onPressed: () =>
                                              menuItem.onTap(tabId),
                                          child: Text(menuItem.title),
                                        );
                                      }),
                                    ],
                                  )
                                : const SizedBox.shrink(),
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
        );
      },
    );
  }
}
