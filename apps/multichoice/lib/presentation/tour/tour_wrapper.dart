import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

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
    return BlocBuilder<TourBloc, TourState>(
      builder: (context, state) {
        if (state.isSkipped || state.isTourComplete) {
          return child;
        }

        return Showcase(
          key: globalKey,
          description: description,
          child: child,
          onTargetClick: () {
            context.read<TourBloc>().add(const TourEvent.nextStep());
          },
          onToolTipClick: () {
            context.read<TourBloc>().add(const TourEvent.nextStep());
          },
        );
      },
    );
  }
}
