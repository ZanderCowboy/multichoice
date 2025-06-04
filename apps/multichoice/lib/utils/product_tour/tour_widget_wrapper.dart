import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/utils/product_tour/tour_config.dart';
import 'package:multichoice/utils/product_tour/utils/get_product_tour_key.dart';
import 'package:showcaseview/showcaseview.dart';

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
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.currentStep == step) {
          final key = getProductTourKey(step, tabId: tabId);
          final showcaseData = TourConfig.getShowcaseData(step);

          if (key != null) {
            return Showcase(
              key: key,
              description: showcaseData.description,
              onTargetClick: showcaseData.onTargetClick,
              disposeOnTap: showcaseData.disposeOnTap,
              disableBarrierInteraction: showcaseData.disableBarrierInteraction,
              onBarrierClick: showcaseData.onBarrierClick,
              overlayOpacity: showcaseData.overlayOpacity,
              child: child,
            );
          }
        }
        return child;
      },
    );
  }
}
