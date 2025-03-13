part of '_base.dart';

class AddTabCard extends StatelessWidget {
  const AddTabCard({
    required this.onPressed,
    this.semanticLabel,
    this.width,
    this.color,
    super.key,
  });

  final String? semanticLabel;
  final double? width;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      semanticLabel: semanticLabel ?? 'AddTab',
      elevation: 5,
      color: color ?? context.theme.appColors.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular12,
      ),
      child: Padding(
        padding: allPadding6,
        child: SizedBox(
          key: context.keys.addTabSizedBox,
          width: width,
          child: IconButton(
            iconSize: 36,
            onPressed: onPressed,
            icon: const Icon(Icons.add_outlined),
          ),
        ),
      ),
    );
  }
}
