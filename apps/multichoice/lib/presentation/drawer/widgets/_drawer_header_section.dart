part of '../home_drawer.dart';

class _DrawerHeaderSection extends StatelessWidget {
  const _DrawerHeaderSection();

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: allPadding12,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: borderCircular12,
            child: Image.asset(
              Assets.images.playstore.path,
              width: 48,
              height: 48,
            ),
          ),
          gap16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Multichoice',
                  style: AppTypography.titleLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                gap4,
                TourWidgetWrapper(
                  step: ProductTourStep.showDetails,
                  child: Text(
                    'Welcome back!',
                    style: AppTypography.subtitleMedium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TourWidgetWrapper(
            step: ProductTourStep.closeSettings,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: TooltipEnums.close.tooltip,
              icon: const Icon(
                Icons.close_outlined,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
