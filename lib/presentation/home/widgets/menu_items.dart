part of '../home_page.dart';

typedef _TabsMenuItems = ({
  String title,
  void Function(String tabId) onTap,
});

typedef _EntryMenuItems = ({
  String title,
  void Function(String tabId, String entryId) onTap,
});

List<_TabsMenuItems> _getTabsMenuItems(BuildContext context) {
  return <_TabsMenuItems>[
    (
      title: MenuItems.rename.name,
      onTap: (_) {},
    ),
    (
      title: MenuItems.delete.name,
      onTap: (value) {
        context.read<HomeBloc>().add(
              HomeEvent.onLongPressedDeleteTab(value),
            );
      },
    ),
  ];
}

List<_EntryMenuItems> _getEntryMenuItems(BuildContext context) {
  return <_EntryMenuItems>[
    (
      title: MenuItems.rename.name,
      onTap: (_, __) {},
    ),
    (
      title: MenuItems.delete.name,
      onTap: (tabId, entryId) {
        context.read<EntryBloc>().add(
              EntryEvent.onLongPressedDeleteEntry(tabId, entryId),
            );
      },
    ),
  ];
}
