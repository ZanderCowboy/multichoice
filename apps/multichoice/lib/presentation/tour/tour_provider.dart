import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

class TourProvider extends StatelessWidget {
  const TourProvider({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => coreSl<TourBloc>()
        ..add(
          const TourEvent.initialize(),
        ),
      child: BlocBuilder<TourBloc, TourState>(
        builder: (context, state) {
          if (state.isSkipped || state.isTourComplete) {
            return child;
          }

          return ShowCaseWidget(
            builder: (context) => child,
            onFinish: () {
              context.read<TourBloc>().add(const TourEvent.completeTour());
            },
            // autoPlay: true,
            // autoPlayDelay: const Duration(seconds: 1),
            enableAutoPlayLock: true,
          );
        },
      ),
    );
  }
}
