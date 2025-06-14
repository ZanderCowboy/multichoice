part of '../home_page.dart';

class CollectionTab extends HookWidget {
  const CollectionTab({
    required this.tab,
    super.key,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );
    final collectionKey = useMemoized(GlobalKey.new, []);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        // Start highlight animation if this tab is highlighted
        if (state.highlightedItemId == tab.id) {
          animationController.forward(from: 0);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Scrollable.ensureVisible(
              collectionKey.currentContext ?? context,
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

        return GestureDetector(
          onLongPress: () => _onDeleteTab(context),
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
            child: TabLayout(tab: tab),
          ),
        );
      },
    );
  }

  void _onDeleteTab(BuildContext context) {
    deleteModal(
      context: context,
      title: tab.title,
      content: Text(
        "Are you sure you want to delete tab ${tab.title} and all it's entries?",
      ),
      onConfirm: () {
        context.read<HomeBloc>().add(HomeEvent.onLongPressedDeleteTab(tab.id));
        Navigator.of(context).pop();
      },
    );
  }
}
