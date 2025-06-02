import 'package:flutter/material.dart';

class ShowcaseData {
  const ShowcaseData({
    required this.description,
    this.onTargetClick,
    this.disposeOnTap = false,
    this.disableBarrierInteraction = false,
    this.onBarrierClick,
  });

  factory ShowcaseData.empty() => const ShowcaseData(
        description: '',
      );

  final String description;
  final VoidCallback? onTargetClick;
  final bool disposeOnTap;
  final bool disableBarrierInteraction;
  final VoidCallback? onBarrierClick;
}
