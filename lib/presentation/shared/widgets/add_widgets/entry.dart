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
      color: context.theme.appColors.secondaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular5,
      ),
      padding: allPadding6,
      icon: const Icon(
        Icons.add_outlined,
        // color: context.theme.appColors.ternary,
      ),
      iconSize: 36,
    );
  }
}
