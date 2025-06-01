import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

/// This is the Showcase that is wrapper around the widget that needs to be showcased.
class TourWrapper extends StatelessWidget {
  const TourWrapper({
    required this.child,
    required this.globalKey,
    required this.description,
    required this.step,
    super.key,
  });

  final Widget child;
  final GlobalKey globalKey;
  final String description;
  final int step;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TourBloc, TourState>(
      listener: (context, state) {
        ShowCaseWidget.of(context).startShowCase([globalKey]);
      },
      builder: (context, state) {
        if (state.isSkipped || state.isTourComplete) {
          return child;
        }

        return Showcase(
          key: globalKey,
          description: description,
          onTargetClick: () {
            context.read<TourBloc>().add(const TourEvent.nextStep());
          },
          disposeOnTap: true,
          onToolTipClick: () {
            context.read<TourBloc>().add(const TourEvent.nextStep());
          },
          targetShapeBorder: const CircleBorder(),
          targetPadding: const EdgeInsets.all(8),
          tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
          textColor: Theme.of(context).colorScheme.onPrimary,
          child: child,
        );
      },
    );
  }
}
