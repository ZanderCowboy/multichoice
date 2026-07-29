import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/spacing_constants.dart';

/// Horizontal [PageView] carousel with optional auto-advance and page dots.
///
/// [children] should be non-empty. When only one child is passed, auto-advance
/// and indicators are omitted.
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    required this.children,
    super.key,
    this.autoAdvanceInterval = const Duration(seconds: 6),
    this.showPageIndicators = true,
    this.height = 120,
    this.indicatorSpacing = gap8,
  }) : assert(
         children.length > 0,
         'BannerCarousel requires at least one child',
       );

  final List<Widget> children;
  final Duration autoAdvanceInterval;
  final bool showPageIndicators;

  /// Fixed height for the page viewport (banner content should fit within).
  final double height;

  final Widget indicatorSpacing;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final PageController _pageController;
  Timer? _autoTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scheduleAutoAdvance();
  }

  @override
  void didUpdateWidget(BannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _currentIndex = _currentIndex.clamp(0, widget.children.length - 1);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) return;
        _pageController.jumpToPage(_currentIndex);
      });
      _scheduleAutoAdvance();
    }
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _scheduleAutoAdvance() {
    _autoTimer?.cancel();
    if (widget.children.length <= 1) return;

    _autoTimer = Timer.periodic(widget.autoAdvanceInterval, (_) {
      if (!mounted) return;
      final count = widget.children.length;
      if (count <= 1) return;
      if (!_pageController.hasClients) return;
      final next = (_currentIndex + 1) % count;
      // Avoid animating during the same frame as a rebuild (inspector / layout).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) return;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    // Restart timer so manual swipe gets a fresh interval before next auto step.
    _scheduleAutoAdvance();
  }

  @override
  Widget build(BuildContext context) {
    final showDots = widget.showPageIndicators && widget.children.length > 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: widget.children,
          ),
        ),
        if (showDots) ...[
          widget.indicatorSpacing,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.children.length, (i) {
              final active = i == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: active ? 16 : 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: active ? 0.85 : 0.28),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
