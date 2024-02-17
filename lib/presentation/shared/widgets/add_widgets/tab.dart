part of '_base.dart';

class AddTabCard extends StatelessWidget {
  const AddTabCard({
    this.semanticLabel,
    this.width,
    super.key,
  });

  final String? semanticLabel;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      semanticLabel: semanticLabel ?? '',
      elevation: 5,
      color: Colors.grey[600],
      shape: RoundedRectangleBorder(
        borderRadius: circularBorder12,
      ),
      child: Padding(
        padding: allPadding6,
        child: SizedBox(
          width: width,
          child: const IconButton(
            iconSize: 36,
            onPressed: null,
            icon: Icon(Icons.add_outlined),
          ),
        ),
      ),
    );
  }
}
