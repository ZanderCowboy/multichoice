part of '../home_page.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    required this.tabId,
    this.onOpen,
    this.onClose,
    super.key,
  });

  final int tabId;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
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
      onOpen: onOpen,
      onClose: onClose,
      //! TODO(ZK): Add confirmation dialog to pop up when delete option is selected in menu
      menuChildren: [
        ..._getTabsMenuItems(context).map((menuItem) {
          return MenuItemButton(
            onPressed: () => menuItem.onTap(tabId),
            child: Text(menuItem.title),
          );
        }),
      ],
    );
  }
}
