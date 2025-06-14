part of '../home_page.dart';

class EntryCard extends HookWidget {
  const EntryCard({
    required this.entry,
    required this.onDoubleTap,
    super.key,
  });

  final EntryDTO entry;
  final VoidCallback onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final menuController = MenuController();
    final appLayout = context.watch<AppLayout>();
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );
    final cardKey = useMemoized(GlobalKey.new, []);

    if (!appLayout.isInitialized) {
      return CircularLoader.small();
    }

    final isLayoutVertical = appLayout.isLayoutVertical;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (_, state) {
        if (state.highlightedItemId == entry.id) {
          animationController.forward(from: 0);
          // Ensure the item is visible when highlighted
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Scrollable.ensureVisible(
              cardKey.currentContext ?? context,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        } else if (state.highlightedItemId == null) {
          if (animationController.isCompleted) {
            animationController.reverse();
          } else if (animationController.isAnimating) {
            animationController
              ..stop()
              ..reverse();
          }
        }

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
            onDoubleTap: onDoubleTap,
            onLongPress: () {
              if (menuController.isOpen) {
                menuController.close();
              } else {
                menuController.open();
              }
            },
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: borderCircular5,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(
                              alpha: animationController.value * 0.5,
                            ),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Padding(
                padding: isLayoutVertical ? allPadding2 : allPadding4,
                child: Card(
                  key: cardKey,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.title,
                            style:
                                context.theme.appTextTheme.titleSmall?.copyWith(
                              fontSize: 16,
                              letterSpacing: 0.3,
                              height: 1,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          gap4,
                          Text(
                            entry.subtitle,
                            style: context.theme.appTextTheme.subtitleSmall
                                ?.copyWith(
                              fontSize: 12,
                              letterSpacing: 0.5,
                              height: 1.25,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ],
                      ),
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
