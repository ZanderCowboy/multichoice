// The context is used synchronously in this file, and the asynchronous usage is safe here.
// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/layout/app_layout.dart';
import 'package:multichoice/constants/export.dart';
import 'package:multichoice/layouts/export_layouts.dart';
import 'package:multichoice/presentation/drawer/home_drawer.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
import 'package:multichoice/presentation/shared/widgets/modals/delete_modal.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:multichoice/utils/product_tour/product_tour.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

part 'widgets/items.dart';
part 'widgets/entry_card.dart';
part 'widgets/menu_widget.dart';
part 'widgets/new_entry.dart';
part 'widgets/new_tab.dart';
part 'widgets/collection_tab.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  // Needs to be refactored
  // ignore: unused_element
  Future<void> _checkAndRequestPermissions() async {
    var status = await Permission.manageExternalStorage.status;

    if (status.isGranted) {
      return;
    }

    if (status.isDenied) {
      await showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          coreSl<SharedPreferences>().setBool('isPermissionsChecked', true);

          return AlertDialog(
            title: const Text('Permission Required'),
            content:
                const Text('Storage permission is required for import/export.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Deny'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  status = await Permission.manageExternalStorage.request();
                  // openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          );
        },
      );

      // final _status = await Permission.manageExternalStorage.request();

      if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Storage permission will be needed for import/export.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstTooltip = GlobalKey();
    final secondTooltip = GlobalKey();

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return BlocProvider(
      create: (_) => coreSl<HomeBloc>()
        ..add(
          const HomeEvent.onGetTabs(),
        ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (context) => AppLayout(),
            builder: (context, child) => ProductTour(
              firstTooltip: firstTooltip,
              secondTooltip: secondTooltip,
              builder: (context) {
                return Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    title: const Text('Multichoice'),
                    actions: [
                      Showcase(
                        key: firstTooltip,
                        description: 'Delete all data',
                        onBarrierClick: () => productTourController.nextStep(
                          context: context,
                        ),
                        child: IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Search has not been implemented yet.'),
                                ),
                              );
                          },
                          tooltip: TooltipEnums.search.tooltip,
                          icon: const Icon(Icons.search_outlined),
                        ),
                      ),
                    ],
                    leading: IconButton(
                      onPressed: () {
                        scaffoldKey.currentState?.openDrawer();
                      },
                      tooltip: TooltipEnums.settings.tooltip,
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ),
                  drawer: const HomeDrawer(),
                  body: const _HomePage(),
                );
              },
            ),
          );
        },
      ),
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
