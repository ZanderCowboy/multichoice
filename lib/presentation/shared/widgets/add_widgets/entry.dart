part of '_base.dart';

class AddEntryCard extends StatelessWidget {
  const AddEntryCard({
    this.semanticLabel,
    super.key,
  });

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      semanticLabel: semanticLabel ?? '',
      elevation: 5,
      color: Colors.grey[600],
      shape: RoundedRectangleBorder(
        borderRadius: circularBorder5,
      ),
      padding: allPadding6,
      icon: const Icon(Icons.add_outlined),
      iconSize: 36,
    );
  }
}
