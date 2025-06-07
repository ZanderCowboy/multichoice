import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/theme/app_typography.dart';
import 'package:multichoice/generated/assets.gen.dart';
import 'package:multichoice/presentation/drawer/widgets/export.dart';
import 'package:multichoice/utils/product_tour/tour_widget_wrapper.dart';
import 'package:ui_kit/ui_kit.dart';

class TutorialDrawer extends StatelessWidget {
  const TutorialDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width,
      backgroundColor: context.theme.appColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DrawerHeader(
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
          ),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: const [
                AppearanceSection(),
                Divider(height: 32),
                DataSection(),
                Divider(height: 32),
                MoreSection(),
              ],
            ),
          ),
          const AppVersion(),
        ],
      ),
    );
  }
}
