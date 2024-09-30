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
      semanticLabel: semanticLabel ?? '',
      elevation: 5,
      color: color ?? context.theme.appColors.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular12,
      ),
      child: Padding(
        padding: allPadding6,
        child: SizedBox(
          width: width,
          child: Showcase(
            key: coreSl<ShowcaseManager>().addTabCardKey,
            title: 'New Column',
            description: 'Adds a new column to the list',
            onBarrierClick: () => debugPrint('Tabs Barrier clicked'),
            tooltipPosition: TooltipPosition.top,
            disposeOnTap: true,
            onTargetClick: onPressed,
            child: IconButton(
              onPressed: onPressed,
              iconSize: 36,
              icon: const Icon(Icons.add_outlined),
            ),
          ),
        ),
      ),
    );
  }
}
