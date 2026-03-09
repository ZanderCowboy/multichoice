import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class AnalyticsPageTracker extends StatefulWidget {
  const AnalyticsPageTracker({
    required this.page,
    required this.child,
    super.key,
  });

  final AnalyticsPage page;
  final Widget child;

  @override
  State<AnalyticsPageTracker> createState() => _AnalyticsPageTrackerState();
}

class _AnalyticsPageTrackerState extends State<AnalyticsPageTracker> {
  static AnalyticsPage? _lastTrackedPage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await coreSl<IAnalyticsService>().logScreenView(
        ScreenViewEventData(
          page: widget.page,
          previousPage: _lastTrackedPage,
        ),
      );
      _lastTrackedPage = widget.page;
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
