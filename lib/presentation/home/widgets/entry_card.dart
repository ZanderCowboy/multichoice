part of '../home_page.dart';

class EntryCard extends HookWidget {
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
    final isHovered = useState<bool>(false);
    final isInMenu = useState<bool>(false);

    return Card(
      elevation: 5,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: circularBorder5,
      ),
      color: Colors.blueGrey,
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) {
          if (!isInMenu.value) {
            isHovered.value = false;
          }
        },
        child: SizedBox(
          width: 200,
          child: Padding(
            padding: allPadding4,
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
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
                            icon: const Icon(Icons.more_vert_outlined),
                            hoverColor: Colors.pink,
                            padding: EdgeInsets.zero,
                          );
                        },
                        onOpen: () => isInMenu.value = true,
                        onClose: () => isInMenu.value = false,
                        menuChildren: [
                          ..._getEntryMenuItems(context).map((menuItem) {
                            return MenuItemButton(
                              onPressed: () =>
                                  menuItem.onTap(tabId ?? '', entryId ?? ''),
                              child: Text(menuItem.title),
                            );
                          }),
                        ],
                      )
                    : const SizedBox.shrink(),
                Row(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
