// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/app/export_app.dart';
import 'package:multichoice/app/view/layout/app_layout.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/layouts/export_layouts.dart';
import 'package:multichoice/presentation/drawer/home_drawer.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
import 'package:multichoice/presentation/shared/widgets/modals/delete_modal.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

part 'utils/_check_and_request_permissions.dart';
part 'widgets/_app_bar.dart';
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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final showcaseManager = coreSl<ShowcaseManager>();
    final sharedPref = coreSl<SharedPreferences>();

    // showcaseManager.startShowcase(context);

    final isPermissionsChecked =
        sharedPref.getBool('isPermissionsChecked') ?? false;
    final hasShowcaseStarted = sharedPref.getBool('hasShowcaseStarted') ?? true;
    final isStepOneFinished = sharedPref.getBool('isShowcaseFinished') ?? false;
    final isStepTwoFinished = sharedPref.getBool('isStepTwoFinished') ?? false;
    final isStepThreeFinished =
        sharedPref.getBool('isStepThreeFinished') ?? false;
    final isStepFourFinished =
        sharedPref.getBool('isStepFourFinished') ?? false;
    final isShowcaseFinished =
        sharedPref.getBool('isShowcaseFinished') ?? false;

    if (!isPermissionsChecked) _checkAndRequestPermissions(context);

    // if (!hasShowcaseStarted) {
    //   startDialog(context);
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!hasShowcaseStarted) {
        startDialog(context);
      }
    });

    // if (!hasShowcaseStarted) {
    //   CustomDialog<AboutDialog>.show(
    //     context: context,
    //     title: const Text('Welcome to Multichoice'),
    //     content: const Text(
    //       'Multichoice is a simple app that can be used to manage your data.\n\n'
    //       'You can create tabs and add entries to them.\n\n'
    //       'You can also import and export your data.\n\n'
    //       'Start product tour.',
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           showcaseManager.startShowcase(context);
    //           Navigator.of(context).pop();
    //         },
    //         child: const Text('Start Tour'),
    //       ),
    //     ],
    //   );
    // }
    // if (!isStepOneFinished ||
    //     !isStepTwoFinished ||
    //     !isStepThreeFinished ||
    //     !isStepFourFinished) {
    //   CustomDialog<AboutDialog>.show(
    //     context: context,
    //     title: const Text('Product Tour'),
    //     content: const Text(
    //       'Do you want to continue the product tour?',
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //           coreSl<SharedPreferences>()
    //               .setBool(Keys.isShowcaseFinished, true);
    //         },
    //         child: const Text('Skip'),
    //       ),
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //           if (!isStepOneFinished) {
    //             coreSl<ShowcaseManager>().startShowcase(context);
    //           } else if (!isStepTwoFinished) {
    //             coreSl<ShowcaseManager>().startEditEntryShowcase(context);
    //           } else if (!isStepThreeFinished) {
    //             coreSl<ShowcaseManager>().startSearchShowcase(context);
    //           } else if (!isStepFourFinished) {
    //             coreSl<ShowcaseManager>().startInfoShowcase(context);
    //           }
    //         },
    //         child: const Text('Continue'),
    //       ),
    //     ],
    //   );
    // }

    // if (isShowcaseFinished) {
    //   CustomDialog<AboutDialog>.show(
    //     context: context,
    //     title: const Text('Product Tour'),
    //     content: const Text(
    //       'This is the end of the product tour.\n\n',
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //         },
    //         child: const Text('Finish Tour'),
    //       ),
    //     ],
    //   );
    // }
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
          return ChangeNotifierProvider(
            create: (context) => AppLayout(),
            builder: (context, child) => Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: const Text('Multichoice'),
                actions: [
                  IconButton(
                    onPressed: () {
                      ShowcaseController.resetShowcase();
                      coreSl<ShowcaseManager>().startShowcase(context);
                    },
                    icon: const Icon(
                      Icons.play_arrow,
                    ),
                  ),
                  Showcase(
                    key: coreSl<ShowcaseManager>().searchButton,
                    title: 'Search',
                    description: 'Search for tabs or entries',
                    onBarrierClick: () => debugPrint('Barrier clicked'),
                    disposeOnTap: true,
                    onTargetClick: () {
                      coreSl<ShowcaseManager>().startSettingsShowcase(context);
                    },
                    child: IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Search has not been implemented yet.'),
                            ),
                          );
                      },
                      tooltip: TooltipEnums.search.tooltip,
                      icon: const Icon(Icons.search_outlined),
                    ),
                  ),
                ],
                leading: Showcase(
                  key: coreSl<ShowcaseManager>().openSettings,
                  title: 'Settings',
                  description: 'Open the settings drawer',
                  onBarrierClick: () => debugPrint('Barrier clicked'),
                  disposeOnTap: true,
                  onTargetClick: () {
                    scaffoldKey.currentState?.openDrawer();
                    coreSl<ShowcaseManager>().startInfoShowcase(context);
                  },
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
    final sharedPref = coreSl<SharedPreferences>();
    // final showcaseManager = coreSl<ShowcaseManager>();
    final hasShowcaseStarted = sharedPref.getBool('hasShowcaseStarted') ?? true;

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

Future<void> startDialog(BuildContext context) async {
  await showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Welcome to Multichoice'),
        content: const Text(
          'Multichoice is a simple app that can be used to manage your data.\n\n'
          'You can create tabs and add entries to them.\n\n'
          'You can also import and export your data.\n\n'
          'Start product tour.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              coreSl<ShowcaseManager>().startShowcase(context);
              Navigator.of(context).pop();
            },
            child: const Text('Start Tour'),
          ),
        ],
      );
    },
  );
}
