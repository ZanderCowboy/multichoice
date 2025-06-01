import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/engine/tooltip_enums.dart';
import 'package:multichoice/app/view/layout/app_layout.dart';
import 'package:multichoice/layouts/export_layouts.dart';
import 'package:multichoice/presentation/drawer/home_drawer.dart';
import 'package:multichoice/presentation/tour/product_tour.dart';
import 'package:multichoice/presentation/tour/tour_controller.dart';
import 'package:multichoice/presentation/tour/tour_wrapper.dart';
import 'package:provider/provider.dart';

@RoutePage()
class TourHomePage extends StatefulWidget {
  const TourHomePage({super.key});

  @override
  TourHomePageState createState() => TourHomePageState();
}

class TourHomePageState extends State<TourHomePage> {
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => coreSl<HomeBloc>()
            ..add(
              const HomeEvent.onGetTabs(),
            ),
        ),
        BlocProvider(
          create: (context) => coreSl<TourBloc>()
            ..add(
              const TourEvent.initialize(),
            ),
        ),
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (context) => AppLayout(),
            builder: (context, child) => ProductTour(
              builder: (context) => Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  title: const Text('Multichoice'),
                  actions: [
                    TourWrapper(
                      globalKey: TourController.getStepKey(0),
                      description: TourController.getStepDescription(0),
                      step: 0,
                      child: IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Search has not been implemented yet.',
                                ),
                              ),
                            );
                        },
                        tooltip: TooltipEnums.search.tooltip,
                        icon: const Icon(Icons.search_outlined),
                      ),
                    ),
                  ],
                  leading: TourWrapper(
                    globalKey: TourController.getStepKey(6),
                    description: TourController.getStepDescription(6),
                    step: 6,
                    child: IconButton(
                      onPressed: () {
                        scaffoldKey.currentState?.openDrawer();
                      },
                      tooltip: TooltipEnums.settings.tooltip,
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ),
                ),
                drawer: const HomeDrawer(),
                body: const _TourHomePage(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TourHomePage extends StatelessWidget {
  const _TourHomePage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final tabs = state.tabs ?? [];

        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        return HomeLayout(
          tabs: tabs,
        );
      },
    );
  }
}
