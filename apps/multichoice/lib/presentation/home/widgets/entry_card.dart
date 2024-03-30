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
                context.read<HomeBloc>().add(
                      HomeEvent.onUpdateEntry(entry.id),
                    );
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
            onTap: () {
              CustomDialog<AlertDialog>.show(
                context: context,
                title: SizedBox(
                  width: 150,
                  child: Text(
                    entry.title,
                  ),
                ),
                content: Text(entry.subtitle),
              );
            },
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
            child: Padding(
              padding: allPadding4,
              child: Card(
                elevation: 3,
                shadowColor: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: borderCircular5,
                ),
                margin: EdgeInsets.zero,
                color: context.theme.appColors.secondary,
                child: Padding(
                  padding: allPadding4,
                  child: SizedBox(
                    height: UIConstants.entryHeight(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          entry.title,
                          style: context.theme.appTextTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          entry.subtitle,
                          style: context.theme.appTextTheme.subtitleSmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
