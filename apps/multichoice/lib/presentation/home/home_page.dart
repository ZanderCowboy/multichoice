import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/app/extensions/extension_getters.dart';
import 'package:multichoice/app/view/theme/app_theme.dart';
import 'package:multichoice/app/view/theme/theme_extension/app_theme_extension.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'widgets/cards.dart';
part 'widgets/entry_card.dart';
part 'widgets/drawer.dart';
part 'widgets/menu_widget.dart';
part 'widgets/new_entry.dart';
part 'widgets/new_tab.dart';
part 'widgets/vertical_tab.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => coreSl<HomeBloc>()
        ..add(
          const HomeEvent.onGetTabs(),
        ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
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
                  icon: const Icon(Icons.search_outlined),
                ),
              ],
            ),
            drawer: const _HomeDrawer(),
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
