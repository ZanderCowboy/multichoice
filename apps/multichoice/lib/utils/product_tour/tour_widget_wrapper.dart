import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/utils/product_tour/utils/get_product_tour_key.dart';
import 'package:showcaseview/showcaseview.dart';

part 'utils/_get_product_tour_data.dart';

class TourWidgetWrapper extends StatelessWidget {
  const TourWidgetWrapper({
    required this.step,
    required this.child,
    this.tabId,
    super.key,
  });

  final Widget child;
  final ProductTourStep step;
  final int? tabId;

  @override
  Widget build(BuildContext context) {
    TooltipPosition getTooltipPosition(Position? step) {
      switch (step ?? Position.bottom) {
        case Position.top:
          return TooltipPosition.top;
        case Position.bottom:
          return TooltipPosition.bottom;
      }
    }

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.currentStep != step) {
          return child;
        }

        final key = getProductTourKey(step, tabId: tabId);
        final showcaseData = _getProductTourData(step);
        final isLightMode = Theme.of(context).brightness == Brightness.light;

        if (key != null && context.mounted) {
          return Showcase(
            key: key,
            title: showcaseData.title,
            description: showcaseData.description,
            onTargetClick: showcaseData.onTargetClick,
            disposeOnTap: showcaseData.disposeOnTap,
            disableBarrierInteraction:
                showcaseData.disableBarrierInteraction ?? true,
            onBarrierClick: showcaseData.onBarrierClick,
            overlayOpacity: isLightMode
                ? showcaseData.overlayOpacity
                : showcaseData.overlayOpacity * 0.25,
            overlayColor: showcaseData.overlayColor,
            tooltipPosition: getTooltipPosition(showcaseData.tooltipPosition),
            child: child,
          );
        }

        return child;
      },
    );
  }
}
