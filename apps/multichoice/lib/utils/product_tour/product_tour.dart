// ignore_for_file: use_build_context_synchronously, document_ignores

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/utils/product_tour/utils/get_product_tour_key.dart';
import 'package:showcaseview/showcaseview.dart';

part 'widgets/popup.dart';

class ProductTour extends StatefulWidget {
  const ProductTour({
    required this.builder,
    super.key,
  });

  final WidgetBuilder builder;

  @override
  State<ProductTour> createState() => _ProductTourState();
}

class _ProductTourState extends State<ProductTour> {
  bool _isShowingDialog = false;
  final _productTourController = coreSl<IProductTourController>();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => handleProductTour(context),
        );

        return BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state.currentStep == ProductTourStep.reset) {
              handleProductTour(context, shouldRestart: true);
              return;
            } else if (state.currentStep == ProductTourStep.thanksPopup) {
              handleProductTour(context);
              return;
            }

            final key = getProductTourKey(state.currentStep);

            if (key != null) ShowCaseWidget.of(context).startShowCase([key]);
          },
          child: widget.builder(context),
        );
      },
    );
  }

  Future<void> handleProductTour(
    BuildContext context, {
    bool shouldRestart = false,
  }) async {
    if (_isShowingDialog && !shouldRestart) return;

    await _productTourController.currentStep.then((currentStep) {
      if (!context.mounted || currentStep == ProductTourStep.noneCompleted) {
        return;
      }

      if (currentStep == ProductTourStep.thanksPopup) {
        _isShowingDialog = true;
        Future.delayed(
          const Duration(milliseconds: 300),
          () => openThanksPopup(context),
        );
      } else if (currentStep == ProductTourStep.welcomePopup || shouldRestart) {
        _isShowingDialog = true;
        openWelcomePopup(context);
      }
    });
  }

  void openWelcomePopup(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialog<AlertDialog>(
          context: context,
          builder: (_) => _Popup(
            context: context,
            title: 'Welcome to Multichoice',
            content: 'This is a product tour to help you get started. '
                'You can skip it at any time.',
            buttonText: 'Next',
          ),
        ).then(
          (_) {
            _isShowingDialog = false;
          },
        );
      },
    );
  }

  void openThanksPopup(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialog<AlertDialog>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Thank you!'),
              content: const Text('You have completed the product tour. '
                  'You can always access it again from the settings.\n\n Would you like to clear all dummy data?'),
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(
                          const HomeEvent.onPressedDeleteAll(),
                        );
                  },
                  child: const Text('Clear Data'),
                ),
                TextButton(
                  onPressed: () {
                    coreSl<ProductBloc>().add(const ProductEvent.resetTour());
                    Navigator.of(context).pop();
                  },
                  child: const Text('Restart Tour'),
                ),
                TextButton(
                  onPressed: () {
                    coreSl<ProductBloc>().add(const ProductEvent.skipTour());
                    Navigator.of(context).pop();
                  },
                  child: const Text('Skip Tour'),
                ),
                TextButton(
                  onPressed: () {
                    coreSl<ProductBloc>().add(const ProductEvent.skipTour());
                    Navigator.of(context).pop();
                  },
                  child: const Text('Finish'),
                ),
              ],
            );
          },
        ).then(
          (_) {
            _isShowingDialog = false;
          },
        );
      },
    );
  }
}
