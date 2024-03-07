part of '../home_page.dart';

typedef TabsMenuItems = ({
  String title,
  VoidCallback onTap,
});

typedef EntryMenuItems = ({
  String title,
  void Function(int tabId, int entryId) onTap,
});

List<TabsMenuItems> getTabsMenuItems(BuildContext context, int id) {
  return <TabsMenuItems>[
    (
      title: MenuItems.edit.name,
      onTap: () => {},
    ),
    (
      title: MenuItems.delete.name,
      onTap: () {
        coreSl<HomeBloc>().add(HomeEvent.onLongPressedDeleteTab(id));
      },
    ),
  ];
}

List<EntryMenuItems> getEntryMenuItems(BuildContext context) {
  return <EntryMenuItems>[
    (
      title: MenuItems.edit.name,
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
