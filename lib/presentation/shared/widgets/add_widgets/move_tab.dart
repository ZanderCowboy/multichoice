part of '_base.dart';

class MoveTab extends StatelessWidget {
  const MoveTab({
    required this.child,
    this.semanticLabel,
    this.width,
    super.key,
  });

  final String? semanticLabel;
  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      semanticLabel: semanticLabel ?? '',
      elevation: 5,
      color: Colors.white24,
      shape: RoundedRectangleBorder(
        borderRadius: circularBorder12,
      ),
      child: child ??
          Padding(
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
