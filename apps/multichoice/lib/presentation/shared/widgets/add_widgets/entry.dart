part of '_base.dart';

class AddEntryCard extends StatelessWidget {
  const AddEntryCard({
    required this.onPressed,
    this.semanticLabel,
    super.key,
  });

  final String? semanticLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      semanticLabel: semanticLabel ?? '',
      elevation: 5,
      color: Colors.grey[600],
      shape: RoundedRectangleBorder(
        borderRadius: circularBorder5,
      ),
      child: Padding(
        padding: allPadding6,
        child: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.add_outlined),
          iconSize: 36,
        ),
      ),
    );
  }
}
