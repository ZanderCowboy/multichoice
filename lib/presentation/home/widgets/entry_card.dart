part of 'entry_cards.dart';

class EntryCard extends HookWidget {
  EntryCard({
    required this.title,
    required this.subtitle,
    this.tabId,
    this.entryId,
    super.key,
  });

  final int? tabId;
  final int? entryId;
  final String? title;
  final String? subtitle;

  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _controller,
      consumeOutsideTap: true,
      builder: (context, controller, child) {
        return child ?? const SizedBox.shrink();
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            context
                .read<HomeBloc>()
                .add(HomeEvent.onUpdateEntry(tabId!, entryId!));
            context.router.push(EditEntryPageRoute(ctx: context));
          },
          child: Text(MenuItems.edit.name),
        ),
        MenuItemButton(
          onPressed: () {
            CustomDialog<Widget>.show(
              context: context,
              title: Text('Delete $title'),
              content: SizedBox(
                height: 20,
                child: Text(
                  "Are you sure you want to delete entry $title and all it's content?",
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    gap10,
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                              HomeEvent.onLongPressedDeleteEntry(
                                tabId!,
                                entryId!,
                              ),
                            );
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            );
          },
          child: Text(MenuItems.delete.name),
        ),
      ],
      child: GestureDetector(
        onDoubleTap: () {
          context
              .read<HomeBloc>()
              .add(HomeEvent.onUpdateEntry(tabId!, entryId!));
          context.router.push(EditEntryPageRoute(ctx: context));
        },
        onLongPress: () {
          if (_controller.isOpen) {
            _controller.close();
          } else {
            _controller.open();
          }
        },
        child: Card(
          elevation: 7,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: circularBorder5,
          ),
          color: const Color.fromARGB(255, 81, 153, 187),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: allPadding4,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          title ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          subtitle ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Placeholder(
                    fallbackHeight: 40,
                    fallbackWidth: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
