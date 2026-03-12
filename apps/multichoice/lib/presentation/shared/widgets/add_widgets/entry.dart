part of '_base.dart';

class AddEntryCard extends StatelessWidget {
  const AddEntryCard({
    required this.onPressed,
    required this.padding,
    this.semanticLabel,
    this.color,
    this.margin = allPadding4,
    super.key,
  });

  final String? semanticLabel;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      semanticLabel: semanticLabel ?? '',
      elevation: 0,
      color: color ?? context.theme.appColors.secondaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular5,
      ),
      padding: padding,
      margin: margin,
      icon: const Icon(Icons.add_outlined),
      iconSize: 36,
      onPressed: onPressed,
    );
  }
}
