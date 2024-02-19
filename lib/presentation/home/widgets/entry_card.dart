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
  final int? tabId;
  final int? entryId;

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
                if (isHovered.value)
                  MenuAnchor(
                    consumeOutsideTap: true,
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
                    // TODO(ZK): Add confirmation dialog to pop up when delete option is selected in menu
                    menuChildren: [
                      ..._getEntryMenuItems(context).map((menuItem) {
                        return MenuItemButton(
                          onPressed: () => menuItem.onTap(
                            tabId ?? 0,
                            entryId ?? 0,
                          ),
                          child: Text(menuItem.title),
                        );
                      }),
                    ],
                  )
                else
                  const SizedBox.shrink(),
                Row(
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
