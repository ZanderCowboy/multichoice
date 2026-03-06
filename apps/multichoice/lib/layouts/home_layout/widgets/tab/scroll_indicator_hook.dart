part of '../../tab_layout.dart';

/// A custom hook that manages scroll-to-start indicator state.
///
/// Listens to [scrollController] and returns a [ValueNotifier<bool>] that is
/// `true` when the user has scrolled past [showAfterOffset] pixels.
ValueNotifier<bool> useScrollToStartIndicator(
  ScrollController scrollController, {
  required List<Object?> keys,
  double showAfterOffset = scrollToStartThreshold,
}) {
  final canScrollToStart = useState(false);

  void refreshScrollIndicators() {
    if (!scrollController.hasClients) return;

    final maxScrollExtent = scrollController.position.maxScrollExtent;
    final currentOffset = scrollController.offset;
    canScrollToStart.value =
        maxScrollExtent > 0 && currentOffset >= showAfterOffset;
  }

  useEffect(
    () {
      void listener() => refreshScrollIndicators();

      scrollController.addListener(listener);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        refreshScrollIndicators();
      });

      return () {
        scrollController.removeListener(listener);
      };
    },
    keys,
  );

  return canScrollToStart;
}

/// A circular button that scrolls [scrollController] back to position 0.
///
/// Wraps the icon in [Semantics] and [Tooltip] for accessibility.
Widget _scrollToStartButton({
  required BuildContext context,
  required ScrollController scrollController,
  required String label,
  required IconData icon,
}) {
  return Material(
    color: context.theme.appColors.white,
    shape: const CircleBorder(),
    child: Semantics(
      label: label,
      button: true,
      child: Tooltip(
        message: label,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () async {
            await scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          },
          child: Padding(
            padding: allPadding2,
            child: Icon(
              icon,
              size: 16,
              color: context.theme.appColors.ternary,
            ),
          ),
        ),
      ),
    ),
  );
}
