import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/app/export_app.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/presentation/drawer/home_drawer.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
import 'package:multichoice/presentation/shared/widgets/modals/delete_modal.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';
import 'package:permission_handler/permission_handler.dart';

part 'widgets/cards.dart';
part 'widgets/entry_card.dart';
part 'widgets/menu_widget.dart';
part 'widgets/new_entry.dart';
part 'widgets/new_tab.dart';
part 'widgets/vertical_tab.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    if (await Permission.manageExternalStorage.isGranted) {
      // Permission is already granted, proceed with your logic
      // todo add a dialog to explain why the permission is needed
      // todo add a dialog to request the permission
      return;
    }

    if (await Permission.manageExternalStorage.isDenied) {
      // Request permission
      final status = await Permission.manageExternalStorage.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        // Handle the case where the user has denied the permission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission is required to proceed.'),
          ),
        );
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
      }
    } else {
      // Request permission for the first time
      final status = await Permission.manageExternalStorage.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        // Handle the case where the user has denied the permission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission is required to proceed.'),
          ),
        );
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return BlocProvider(
      create: (_) => coreSl<HomeBloc>()
        ..add(
          const HomeEvent.onGetTabs(),
        ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
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
                          content: Text('Search has not been implemented yet.'),
                        ),
                      );
                  },
                  tooltip: TooltipEnums.search.tooltip,
                  icon: const Icon(Icons.search_outlined),
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

        return Center(
          child: Padding(
            padding: vertical12,
            child: SizedBox(
              height: UIConstants.tabHeight(context),
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                controller: ScrollController(),
                scrollBehavior: CustomScrollBehaviour(),
                slivers: [
                  SliverPadding(
                    padding: left12,
                    sliver: SliverList.builder(
                      itemCount: tabs.length,
                      itemBuilder: (_, index) {
                        final tab = tabs[index];

                        return _VerticalTab(tab: tab);
                      },
                    ),
                  ),
                  const SliverPadding(
                    padding: right12,
                    sliver: SliverToBoxAdapter(
                      child: _NewTab(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
