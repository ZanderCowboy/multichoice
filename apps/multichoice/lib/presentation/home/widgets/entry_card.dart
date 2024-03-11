part of '../home_page.dart';

class _EntryCard extends HookWidget {
  const _EntryCard({required this.entry});

  final EntryDTO entry;

  @override
  Widget build(BuildContext context) {
    final menuController = MenuController();

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return MenuAnchor(
          controller: menuController,
          consumeOutsideTap: true,
          builder: (context, controller, child) {
            return child ?? const SizedBox.shrink();
          },
          menuChildren: [
            MenuItemButton(
              onPressed: () {
                context.read<HomeBloc>().add(HomeEvent.onUpdateEntry(entry.id));
                context.router.push(EditEntryPageRoute(ctx: context));
              },
              child: Text(MenuItems.edit.name),
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
                          text: entry.title,
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
                    "Are you sure you want to delete ${entry.title} and all it's data?",
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                              HomeEvent.onLongPressedDeleteEntry(
                                entry.tabId,
                                entry.id,
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
          child: GestureDetector(
            onDoubleTap: () {
              context.read<HomeBloc>().add(HomeEvent.onUpdateEntry(entry.id));
              context.router.push(EditEntryPageRoute(ctx: context));
            },
            onLongPress: () {
              if (menuController.isOpen) {
                menuController.close();
              } else {
                menuController.open();
              }
            },
            child: Card(
              elevation: 7,
              shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: circularBorder5,
              ),
              color: const Color.fromARGB(255, 81, 153, 187),
              child: Padding(
                padding: allPadding4,
                child: Column(
                  children: [
                    Text(
                      entry.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      entry.subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
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
