part of '../../home_layout.dart';

class _EditModeHelperBanner extends StatelessWidget {
  const _EditModeHelperBanner({
    required this.isLayoutVertical,
  });

  final bool isLayoutVertical;

  @override
  Widget build(BuildContext context) {
    final helperText = isLayoutVertical
        ? 'Drag and drop collections and entries to reorder them.'
        : 'Drag and drop collections to reorder. Long press and drag entries to reorder them.';

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: context.theme.appColors.primaryLight?.withValues(alpha: 0.15),
          borderRadius: borderCircular12,
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 18,
              color: context.theme.appColors.iconColor,
            ),
            gap8,
            Expanded(
              child: Text(
                helperText,
                style: context.appTextTheme.denseSubtitle?.copyWith(
                  color: context.theme.appColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
