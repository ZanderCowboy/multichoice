import 'package:flutter/material.dart';

class ShowcaseData {
  const ShowcaseData({
    required this.description,
    this.onTargetClick,
    this.disposeOnTap,
    this.disableBarrierInteraction = false,
    this.onBarrierClick,
    this.overlayOpacity = 0.5,
    this.overlayColor = Colors.black54,
  });

  factory ShowcaseData.empty() => const ShowcaseData(
        description: '',
      );

  final String description;
  final VoidCallback? onTargetClick;
  final bool? disposeOnTap;
  final bool disableBarrierInteraction;
  final VoidCallback? onBarrierClick;
  final double overlayOpacity;
  final Color overlayColor;
}
