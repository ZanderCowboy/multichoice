import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:multichoice/presentation/tour/tour_controller.dart';
import 'package:multichoice/presentation/tour/tour_wrapper.dart';

class TourCollectionTab extends StatelessWidget {
  const TourCollectionTab({
    required this.tab,
    super.key,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    return TourWrapper(
      globalKey: TourController.getStepKey(1),
      description: TourController.getStepDescription(1),
      step: 1,
      child: CollectionTab(tab: tab),
    );
  }
}
