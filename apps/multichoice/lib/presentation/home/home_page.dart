// The context is used synchronously in this file, and the asynchronous usage is safe here.

// ignore_for_file: deprecated_member_use, document_ignores

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
import 'package:multichoice/presentation/shared/widgets/forms/reusable_form.dart';
import 'package:multichoice/presentation/shared/widgets/modals/delete_modal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:ui_kit/ui_kit.dart';

part 'utils/_check_and_request_permissions.dart';
part 'widgets/collection_tab.dart';
part 'widgets/entry_card.dart';
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
        BlocProvider(
          create: (_) => coreSl<ProductBloc>(),
        ),
        BlocProvider(
          create: (_) => coreSl<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => coreSl<DetailsBloc>(),
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
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(
                      const HomeEvent.onToggleEditMode(),
                    );
                  },
                  tooltip: state.isEditMode ? 'Finish editing' : 'Edit order',
                  icon: Icon(
                    state.isEditMode ? Icons.check : Icons.edit_outlined,
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () async {
                await context.router.push(
                  SearchPageRoute(
                    onBack: () {
                      context.read<HomeBloc>().add(const HomeEvent.refresh());
                      context.router.pop();
                    },
                    onEdit: (result) async {
                      if (result == null) return;

                      if (result.isTab) {
                        final tab = result.item as TabsDTO;
                        context.read<HomeBloc>().add(
                          HomeEvent.onUpdateTabId(tab.id),
                        );
                        await context.router.push(
                          EditTabPageRoute(ctx: context),
                        );
                      } else {
                        final entry = result.item as EntryDTO;
                        context.read<HomeBloc>().add(
                          HomeEvent.onUpdateEntry(entry.id),
                        );
                        await context.router.push(
                          EditEntryPageRoute(ctx: context),
                        );
                      }
                    },
                    onDelete: (result) async {
                      if (result == null) return;

                      if (result.isTab) {
                        final tab = result.item as TabsDTO;
                        context.read<HomeBloc>().add(
                          HomeEvent.onLongPressedDeleteTab(tab.id),
                        );
                      } else {
                        final entry = result.item as EntryDTO;
                        context.read<HomeBloc>().add(
                          HomeEvent.onLongPressedDeleteEntry(
                            entry.tabId,
                            entry.id,
                          ),
                        );
                      }
                    },
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
        body: const HomeLayout(),
      ),
    );
  }
}
