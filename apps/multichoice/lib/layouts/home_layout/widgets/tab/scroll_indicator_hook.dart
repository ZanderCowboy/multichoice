part of '../../tab_layout.dart';

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
              size: 24,
              color: context.theme.appColors.ternary,
            ),
          ),
        ),
      ),
    ),
  );
}
