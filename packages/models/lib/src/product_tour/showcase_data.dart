import 'package:flutter/material.dart';

class ShowcaseData {
  const ShowcaseData({
    required this.description,
    this.title,
    this.onTargetClick,
    this.disposeOnTap = false,
    this.disableBarrierInteraction = true,
    this.onBarrierClick,
    this.overlayOpacity = 0.5,
    this.overlayColor = Colors.black54,
    this.tooltipPosition,
    this.tooltipPadding,
  });

  factory ShowcaseData.empty() => const ShowcaseData(
        description: '',
      );

  final String description;
  final String? title;
  final VoidCallback? onTargetClick;
  final bool? disposeOnTap;
  final bool? disableBarrierInteraction;
  final VoidCallback? onBarrierClick;
  final double overlayOpacity;
  final Color overlayColor;
  final Position? tooltipPosition;
  final EdgeInsets? tooltipPadding;
}

enum Position { top, bottom }
