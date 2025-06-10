// ignore_for_file: use_build_context_synchronously, document_ignores

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/presentation/tutorial/widgets/thanks_modal.dart';
import 'package:multichoice/presentation/tutorial/widgets/tutorial_welcome_modal.dart';
import 'package:multichoice/utils/product_tour/utils/get_product_tour_key.dart';
import 'package:showcaseview/showcaseview.dart';

class ProductTour extends StatefulWidget {
  const ProductTour({
    required this.builder,
    required this.onTourComplete,
    super.key,
  });

  final WidgetBuilder builder;
  final void Function({required bool shouldRestoreData}) onTourComplete;

  @override
  State<ProductTour> createState() => _ProductTourState();
}

class _ProductTourState extends State<ProductTour> {
  bool _isShowingDialog = false;
  final _productTourController = coreSl<IProductTourController>();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (_) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => handleProductTour(context),
        );

        return BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state.currentStep == ProductTourStep.reset) {
              context.read<HomeBloc>().add(const HomeEvent.onGetTabs());
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

      // Only show welcome modal if we have data
      if (currentStep == ProductTourStep.welcomePopup &&
          !_isShowingDialog &&
          (context.read<HomeBloc>().state.tabs?.isNotEmpty ?? false)) {
        _showWelcomeModal(context);
      } else if (currentStep == ProductTourStep.thanksPopup &&
          !_isShowingDialog) {
        _showThanksModal(context);
      }
    });
  }

  void _showWelcomeModal(BuildContext context) {
    _isShowingDialog = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => TutorialWelcomeModal(
        onStart: () {
          Navigator.of(context).pop();
          context.read<ProductBloc>().add(const ProductEvent.nextStep());
        },
      ),
    ).then((_) {
      _isShowingDialog = false;
    });
  }

  void _showThanksModal(BuildContext context) {
    _isShowingDialog = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ThanksModal(
        onGoHome: () async {
          if (context.mounted) {
            coreSl<ProductBloc>().add(const ProductEvent.skipTour());
            widget.onTourComplete(shouldRestoreData: true);
          }
        },
      ),
    ).then((_) {
      _isShowingDialog = false;
    });
  }
}
