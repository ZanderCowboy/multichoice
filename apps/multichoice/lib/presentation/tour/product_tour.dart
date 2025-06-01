import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

class ProductTour extends StatelessWidget {
  const ProductTour({
    required this.builder,
    // required this.child,
    super.key,
  });

  final WidgetBuilder builder;
  // final Widget child;

  @override
  Widget build(BuildContext context) {
    var isShowingStep = false;

    void openWelcomePopup(BuildContext context) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          isShowingStep = true;
          showDialog<AlertDialog>(
            context: context,
            builder: (_) => const _MyPopup(
              title: 'Welcome',
              content: 'Welcome to the app!',
              buttonText: 'Next',
            ),
          ).then(
            (value) {
              isShowingStep = false;
            },
          );
        },
      );
    }

    return ShowCaseWidget(
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            openWelcomePopup(context);
          },
        );

        return builder(context);
      },
      onFinish: () {
        // context.read<TourBloc>().add(const TourEvent.completeTour());
      },
      // autoPlay: true,
      // autoPlayDelay: const Duration(seconds: 1),
      enableAutoPlayLock: true,
    );
  }
}

class _MyPopup extends StatelessWidget {
  const _MyPopup({
    required this.title,
    required this.content,
    required this.buttonText,
  });
  final String title;
  final String content;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            context.read<TourBloc>().add(const TourEvent.nextStep());
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
