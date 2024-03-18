import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/app/extensions/theme_getter.dart';
import 'package:multichoice/app/view/theme/app_theme.dart';
import 'package:multichoice/app/view/theme/theme_extension/app_theme_extension.dart';
import 'package:multichoice/constants/border_constants.dart';
import 'package:multichoice/constants/spacing_constants.dart';
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
      create: (context) => coreSl<HomeBloc>()..add(const HomeEvent.onGetTabs()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Multichoice'),
              actions: [
                IconButton(
                  onPressed: () {
                    context
                        .read<HomeBloc>()
                        .add(const HomeEvent.onPressedDeleteAll());
                  },
                  icon: const Icon(
                    Icons.delete_sweep_rounded,
                  ),
                ),
              ],
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

        return Center(
          child: Padding(
            padding: allPadding12,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height / 1.25,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                controller: ScrollController(),
                scrollBehavior: CustomScrollBehaviour(),
                slivers: [
                  SliverList.builder(
                    itemCount: tabs.length,
                    itemBuilder: (_, index) {
                      final tab = tabs[index];

                      return _VerticalTab(tab: tab);
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: _NewTab(),
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

class _ThemeButton extends StatelessWidget {
  const _ThemeButton({
    required this.sharedPref,
    required this.state,
  });

  final SharedPreferences sharedPref;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    if (state.theme == 'light') {
      return IconButton(
        onPressed: () {
          _darkMode(context);
          sharedPref.setString('theme', 'dark');
          context.read<HomeBloc>().add(const HomeEvent.onPressedTheme());
        },
        icon: const Icon(Icons.dark_mode_outlined),
      );
    } else if (state.theme == 'dark') {
      return IconButton(
        onPressed: () {
          _lightMode(context);
          sharedPref.setString('theme', 'light');
          context.read<HomeBloc>().add(const HomeEvent.onPressedTheme());
        },
        icon: const Icon(Icons.light_mode_outlined),
      );
    }
    return const SizedBox.shrink();
  }

  void _lightMode(BuildContext context) {
    context.read<AppTheme>().themeMode = ThemeMode.light;
  }

  void _darkMode(BuildContext context) {
    context.read<AppTheme>().themeMode = ThemeMode.dark;
  }
}
