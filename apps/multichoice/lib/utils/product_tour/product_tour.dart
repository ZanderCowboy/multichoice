import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

part 'widgets/popup.dart';

class ProductTour extends StatefulWidget {
  const ProductTour({
    required this.builder,
    required this.firstTooltip,
    required this.secondTooltip,
    super.key,
  });

  final WidgetBuilder builder;
  final GlobalKey firstTooltip;
  final GlobalKey secondTooltip;

  @override
  State<ProductTour> createState() => _ProductTourState();
}

class _ProductTourState extends State<ProductTour> {
  bool _isShowingStep = false;

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => handleProductTour(context),
          );
          return widget.builder(context);
        },
      ),
    );
  }

  void handleProductTour(BuildContext context) {
    if (_isShowingStep) return;

    if (productTourController.shouldShowThanksPopup()) {
      openThanksPopup(context);
    } else if (productTourController.shouldShowFirstTooltip()) {
      ShowCaseWidget.of(context).startShowCase([
        widget.firstTooltip,
        widget.secondTooltip,
      ]);
    } else if (productTourController.shouldShowSecondTooltip()) {
      ShowCaseWidget.of(context).startShowCase([
        widget.secondTooltip,
      ]);
    } else if (productTourController.shouldShowWelcomePopup()) {
      openWelcomePopup(context);
    }
  }

  void openWelcomePopup(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _isShowingStep = true;
        showDialog<AlertDialog>(
          context: context,
          builder: (_) => const _MyPopup(
            title: 'Welcome',
            content: 'Welcome to the app!',
            buttonText: 'Next',
          ),
        ).then(
          (_) {
            _isShowingStep = false;
            return handleProductTour(context);
          },
        );
      },
    );
  }

  void openThanksPopup(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _isShowingStep = true;
        showDialog<AlertDialog>(
          context: context,
          builder: (_) => const _MyPopup(
            title: 'Thanks',
            content: 'Thanks for using the app!',
            buttonText: 'Close',
          ),
        ).then(
          (_) {
            _isShowingStep = false;
            return handleProductTour(context);
          },
        );
      },
    );
  }
}
