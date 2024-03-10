part of '../home_page.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    required this.tab,
    super.key,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return MenuAnchor(
          consumeOutsideTap: true,
          builder: (_, menuController, child) {
            return IconButton(
              onPressed: () {
                if (menuController.isOpen) {
                  menuController.close();
                } else {
                  menuController.open();
                }
              },
              icon: const Icon(Icons.more_vert_outlined),
              padding: EdgeInsets.zero,
            );
          },
          menuChildren: [
            MenuItemButton(
              onPressed: () {
                context.read<HomeBloc>().add(HomeEvent.onUpdateTabId(tab.id));
                context.router.push(EditTabPageRoute(ctx: context));
              },
              child: Text(MenuItems.edit.name),
            ),
            MenuItemButton(
              onPressed: () {
                CustomDialog<AlertDialog>.show(
                  context: context,
                  title: RichText(
                    text: TextSpan(
                      text: 'Delete all entries of ',
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 24),
                      children: [
                        TextSpan(
                          text: tab.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '?',
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to delete all the entries of ${tab.title}?',
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                              HomeEvent.onPressedDeleteAllEntries(tab.id),
                            );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete Entries'),
                    ),
                  ],
                );
              },
              child: Text(MenuItems.deleteEntries.name),
            ),
            MenuItemButton(
              onPressed: () {
                CustomDialog<AlertDialog>.show(
                  context: context,
                  title: RichText(
                    text: TextSpan(
                      text: 'Delete ',
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 24),
                      children: [
                        TextSpan(
                          text: tab.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '?',
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  content: Text(
                    "Are you sure you want to delete ${tab.title} and all it's entries?",
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                              HomeEvent.onLongPressedDeleteTab(
                                tab.id,
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
              child: Text(MenuItems.delete.name),
            ),
          ],
        );
      },
    );
  }
}
