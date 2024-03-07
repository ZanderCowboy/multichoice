part of '_base.dart';

class AddEntryCard extends StatelessWidget {
  const AddEntryCard({
    required this.onPressed,
    required this.padding,
    this.semanticLabel,
    super.key,
  });

  final String? semanticLabel;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      semanticLabel: semanticLabel ?? '',
      elevation: 5,
      color: Colors.grey[600],
      shape: RoundedRectangleBorder(
        borderRadius: circularBorder5,
      ),
      padding: padding,
      icon: const Icon(Icons.add_outlined),
      iconSize: 36,
      onPressed: onPressed,
    );
  }
}
