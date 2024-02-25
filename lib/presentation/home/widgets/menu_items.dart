part of '../home_page.dart';

typedef TabsMenuItems = ({
  String title,
  void Function(int tabId) onTap,
});

typedef EntryMenuItems = ({
  String title,
  void Function(int tabId, int entryId) onTap,
});

List<TabsMenuItems> getTabsMenuItems(BuildContext context) {
  return <TabsMenuItems>[
    (
      title: MenuItems.rename.name,
      onTap: (_) {},
    ),
    (
      title: MenuItems.delete.name,
      onTap: (tabId) {
        context.read<HomeBloc>().add(HomeEvent.onLongPressedDeleteTab(tabId));
      },
    ),
  ];
}

List<EntryMenuItems> getEntryMenuItems(BuildContext context) {
  return <EntryMenuItems>[
    (
      title: MenuItems.rename.name,
      onTap: (_, __) {},
    ),
    (
      title: MenuItems.delete.name,
      onTap: (tabId, entryId) {
        context.read<HomeBloc>().add(
              HomeEvent.onLongPressedDeleteEntry(tabId, entryId),
            );
      },
    ),
  ];
}
