// The context is used synchronously in this file, and the asynchronous usage is safe here.
// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/constants/export.dart';
import 'package:multichoice/layouts/export.dart';
import 'package:multichoice/presentation/drawer/home_drawer.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
import 'package:multichoice/presentation/shared/widgets/modals/delete_modal.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:multichoice/utils/product_tour/product_tour.dart';
import 'package:multichoice/utils/product_tour/tour_widget_wrapper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'utils/_check_and_request_permissions.dart';
part 'widgets/collection_tab.dart';
part 'widgets/entry_card.dart';
part 'widgets/items.dart';
part 'widgets/menu_widget.dart';
part 'widgets/new_entry.dart';
part 'widgets/new_tab.dart';

// TODO(@ZanderCowboy): Rework User Tutorial with Existing Data
// When the user has existing data,
// 1. Then the tutorial should first save the existing data to a
//    file (or something)
// 2. Then, it should load the dummy data from the file
// 3. Then, it should show the tutorial with the dummy data
// 4. Finally, it should restore the original data from the file

// TODO(@ZanderCowboy): Ensure both Layouts Work with the Product Tour
// 1. Ensure that the Product Tour works with both the Horizontal and
//  Vertical layouts.

@RoutePage()
class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppLayout(),
        ),
        BlocProvider(
          create: (_) => coreSl<HomeBloc>()
            ..add(
              const HomeEvent.onGetTabs(),
            ),
        ),
        BlocProvider(
          create: (_) => coreSl<ProductBloc>(),
        ),
      ],
      child: ProductTour(
        builder: (_) {
          return const HomePage();
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Multichoice'),
        actions: [
          IconButton(
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
        ],
        leading: TourWidgetWrapper(
          step: ProductTourStep.showSettings,
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
      body: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

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

        return HomeLayout(tabs: tabs);
      },
    );
  }
}
