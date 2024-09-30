part of '../home_page.dart';

class EntryCard extends HookWidget {
  const EntryCard({
    required this.entry,
    super.key,
  });

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
              onPressed: () => _onDeleteEntry(context),
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
              context.router.push(EditEntryPageRoute(ctx: context)).then((_) {
                coreSl<ShowcaseManager>().startEditEntryShowcase(context);
              });
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

  void _onDeleteEntry(BuildContext context) {
    deleteModal(
      context: context,
      title: entry.title,
      content: Text(
        "Are you sure you want to delete ${entry.title} and all it's data?",
      ),
      onConfirm: () {
        context.read<HomeBloc>().add(
              HomeEvent.onLongPressedDeleteEntry(
                entry.tabId,
                entry.id,
              ),
            );
        Navigator.of(context).pop();
      },
    );
  }
}
