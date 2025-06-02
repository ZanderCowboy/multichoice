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
            }

            final key = getProductTourKey(state.currentStep);

            ShowCaseWidget.of(context).startShowCase([key]);
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
      if (currentStep == ProductTourStep.thanksPopup) {
        if (context.mounted) openThanksPopup(context);
      } else if (currentStep == ProductTourStep.welcomePopup || shouldRestart) {
        if (context.mounted) openWelcomePopup(context);
      }
    });
  }

  void openWelcomePopup(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _isShowingDialog = true;
        showDialog<AlertDialog>(
          context: context,
          builder: (_) => const _Popup(
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
        _isShowingDialog = true;
        showDialog<AlertDialog>(
          context: context,
          builder: (_) => const _Popup(
            title: 'Thank you!',
            content: 'You have completed the product tour. '
                'You can always access it again from the settings.',
            buttonText: 'Exit Tour',
            showSkipButton: false,
          ),
        ).then(
          (_) {
            _isShowingDialog = false;
          },
        );
      },
    );
  }
}
