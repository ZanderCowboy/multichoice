import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/tutorial/widgets/export.dart';
import 'package:multichoice/utils/product_tour/product_tour.dart';
import 'package:multichoice/utils/product_tour/tour_widget_wrapper.dart';
import 'package:provider/provider.dart';

@RoutePage()
class TutorialPage extends StatelessWidget {
  const TutorialPage({
    required this.onCallback,
    super.key,
  });

  final void Function() onCallback;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// using BlocProvider.value to avoid the issue where it tries
        /// to add events that is already closed.
        BlocProvider<ProductBloc>.value(
          value: coreSl<ProductBloc>()
            ..add(
              const ProductEvent.onLoadData(),
            ),
        ),
        BlocProvider.value(
          value: coreSl<HomeBloc>(),
        ),
      ],
      child: ProductTour(
        onTourComplete: ({required shouldRestoreData}) {
          if (shouldRestoreData) {
            onCallback.call();
            context.router.popUntilRoot();
          }
        },
        builder: (_) {
          return Scaffold(
            key: scaffoldKeyTutorial,
            appBar: AppBar(
              title: const Text('Multichoice'),
              leading: TourWidgetWrapper(
                step: ProductTourStep.showSettings,
                child: IconButton(
                  onPressed: () {
                    scaffoldKeyTutorial.currentState?.openDrawer();
                  },
                  tooltip: TooltipEnums.settings.tooltip,
                  icon: const Icon(Icons.settings_outlined),
                ),
              ),
            ),
            drawer: const TutorialDrawer(),
            body: const SafeArea(
              child: Stack(
                children: [
                  TutorialBody(),
                  TutorialBanner(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
