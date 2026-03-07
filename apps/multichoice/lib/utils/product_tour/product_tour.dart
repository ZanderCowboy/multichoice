import 'dart:async';

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
  bool _isShowingExitPrompt = false;
  final IProductTourController _productTourController =
      coreSl<IProductTourController>();
  final GlobalKey<ShowCaseWidgetState> _showCaseWidgetKey =
      GlobalKey<ShowCaseWidgetState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await handleProductTour(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ShowCaseWidget is deprecated but migration to ShowcaseView.register()
    // requires architectural changes. Keeping current implementation until
    // proper migration can be planned. See: showcaseview v5.0.0 changelog
    // ignore: deprecated_member_use
    return ShowCaseWidget(
      key: _showCaseWidgetKey,
      builder: (_) {
        return BlocListener<ProductBloc, ProductState>(
          listener: (context, state) async {
            if (state.currentStep == ProductTourStep.reset) {
              context.read<ProductBloc>().add(const ProductEvent.onLoadData());
              await handleProductTour(context, shouldRestart: true);
              return;
            } else if (state.currentStep == ProductTourStep.welcomePopup) {
              await handleProductTour(context);
              return;
            } else if (state.currentStep == ProductTourStep.thanksPopup) {
              await handleProductTour(context);
              return;
            }

            _startShowcaseForStep(state.currentStep);
          },
          child: BlocBuilder<ProductBloc, ProductState>(
            buildWhen: (previous, current) =>
                previous.currentStep != current.currentStep,
            builder: (context, state) {
              final shouldInterceptBack = _shouldInterceptBack(
                state.currentStep,
              );

              return PopScope(
                canPop: !shouldInterceptBack,
                onPopInvokedWithResult: (didPop, _) {
                  if (!shouldInterceptBack ||
                      didPop ||
                      _isShowingDialog ||
                      _isShowingExitPrompt) {
                    return;
                  }

                  _isShowingExitPrompt = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) {
                      _isShowingExitPrompt = false;
                      return;
                    }

                    unawaited(_showExitTutorialPrompt(context));
                  });
                },
                child: widget.builder(context),
              );
            },
          ),
        );
      },
    );
  }

  bool _shouldInterceptBack(ProductTourStep step) {
    return step.value > ProductTourStep.welcomePopup.value &&
        step.value < ProductTourStep.thanksPopup.value;
  }

  void _startShowcaseForStep(ProductTourStep step) {
    if (step == ProductTourStep.welcomePopup ||
        step == ProductTourStep.noneCompleted ||
        step == ProductTourStep.reset) {
      return;
    }

    final key = getProductTourKey(step);
    if (key == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ShowcaseView.get().startShowCase([key]);
    });
  }

  Future<void> handleProductTour(
    BuildContext context, {
    bool shouldRestart = false,
  }) async {
    if (_isShowingDialog && !shouldRestart) return;

    await _productTourController.currentStep.then((currentStep) async {
      if (!context.mounted || currentStep == ProductTourStep.noneCompleted) {
        return;
      }

      // Only show welcome modal if we have data
      if (currentStep == ProductTourStep.welcomePopup &&
          !_isShowingDialog &&
          (context.read<ProductBloc>().state.tabs?.isNotEmpty ?? false)) {
        await _showWelcomeModal(context);
      } else if (currentStep == ProductTourStep.thanksPopup &&
          !_isShowingDialog) {
        await _showThanksModal(context);
      }
    });
  }

  Future<void> _showWelcomeModal(BuildContext context) async {
    _isShowingDialog = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => TutorialWelcomeModal(
        onStart: () {
          Navigator.of(dialogContext, rootNavigator: true).pop();
          context.read<ProductBloc>().add(const ProductEvent.nextStep());
        },
      ),
    ).then((_) {
      _isShowingDialog = false;
    });
  }

  Future<void> _showThanksModal(BuildContext context) async {
    _isShowingDialog = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ThanksModal(
        onGoHome: () async {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext, rootNavigator: true).pop();
            coreSl<ProductBloc>().add(const ProductEvent.skipTour());
            widget.onTourComplete(shouldRestoreData: true);
          }
        },
      ),
    ).then((_) {
      _isShowingDialog = false;
    });
  }

  Future<void> _showExitTutorialPrompt(BuildContext context) async {
    // Dismiss any active showcase overlay so the confirmation dialog is
    // guaranteed to render as the top-most modal.
    ShowcaseView.get().dismiss();

    final productBloc = context.read<ProductBloc>();

    try {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Exit tutorial?'),
            content: const Text(
              'Are you sure you want to exit the tutorial? Your tutorial '
              'progress will be skipped.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop(false);
                },
                child: const Text('Stay'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop(true);
                },
                child: const Text('Exit'),
              ),
            ],
          );
        },
      );

      if (!mounted) {
        return;
      }

      if (shouldExit != true) {
        final currentStep = productBloc.state.currentStep;

        if (_shouldInterceptBack(currentStep)) {
          _startShowcaseForStep(currentStep);
        }

        return;
      }

      productBloc.add(const ProductEvent.skipTour());
      widget.onTourComplete(shouldRestoreData: true);
    } finally {
      _isShowingExitPrompt = false;
    }
  }
}
