// The context is used synchronously in this file, and the asynchronous usage is safe here.
// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/layouts/export.dart';
import 'package:multichoice/presentation/drawer/home_drawer.dart';
import 'package:multichoice/presentation/home/widgets/welcome_modal_handler.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
import 'package:multichoice/presentation/shared/widgets/modals/delete_modal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:ui_kit/ui_kit.dart';

part 'utils/_check_and_request_permissions.dart';
part 'widgets/collection_tab.dart';
part 'widgets/entry_card.dart';
part 'widgets/items.dart';
part 'widgets/menu_widget.dart';
part 'widgets/new_entry.dart';
part 'widgets/new_tab.dart';

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
      child: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeModalHandler(
      builder: (_) => const _HomePage(),
      onSkipTour: () async {
        context.read<ProductBloc>().add(const ProductEvent.skipTour());
      },
      onFollowTutorial: () async {
        await context.router.push(
          TutorialPageRoute(
            onCallback: () {
              context.read<HomeBloc>().add(const HomeEvent.onGetTabs());
            },
          ),
        );
      },
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    // this ShowCaseWidget is here to fix an issue where it complains
    // about ShowCaseView context not being available
    return ShowCaseWidget(
      builder: (context) => Scaffold(
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
          leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            tooltip: TooltipEnums.settings.tooltip,
            icon: const Icon(Icons.settings_outlined),
          ),
        ),
        drawer: const HomeDrawer(),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final tabs = state.tabs ?? [];

            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            return HomeLayout(tabs: tabs);
          },
        ),
      ),
    );
  }
}
