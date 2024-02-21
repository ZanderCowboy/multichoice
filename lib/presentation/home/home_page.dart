import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/application/export_application.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:multichoice/presentation/home/widgets/entry_cards.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
import 'package:multichoice/utils/app_theme.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';
import 'package:multichoice/utils/extensions/theme_getter.dart';
import 'package:multichoice/utils/theme_extension/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'widgets/vertical_tab.dart';
part 'widgets/entry_card.dart';
part 'widgets/empty_tab.dart';
part 'widgets/empty_entry.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => coreSl<HomeBloc>()
        ..add(const HomeEvent.onGetTabs())
        ..add(const HomeEvent.onGetAllEntryCards()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Multichoice'),
              actions: [
                _ThemeButton(
                  // sharedPref: snapshot.requireData,
                  sharedPref: coreSl<SharedPreferences>(),
                  state: state,
                ),
                IconButton(
                  onPressed: () {
                    context
                        .read<HomeBloc>()
                        .add(const HomeEvent.onPressedDeleteAll());
                  },
                  icon: const Icon(
                    Icons.delete_sweep_rounded,
                    // color: context.theme.appColors.primary,
                  ),
                ),
              ],
            ),
            drawer: Drawer(
              width: MediaQuery.sizeOf(context).width,
              backgroundColor: context.theme.appColors.background,
              child: Padding(
                padding: allPadding12,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    gap56,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Settings',
                            style: context.theme.appTextTheme.titleMedium
                                ?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(
                            Icons.close_outlined,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    gap24,
                    _ThemeButton(
                      sharedPref: coreSl<SharedPreferences>(),
                      state: state,
                    ),
                  ],
                ),
              ),
            ),
            body: _HomePage(),
          );
        },
      ),
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

class _HomePage extends StatelessWidget {
  _HomePage();

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final tabs = state.tabs ?? [];

        return Center(
          child: Padding(
            padding: allPadding12,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height / 1.15,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                scrollBehavior: CustomScrollBehaviour(),
                slivers: [
                  SliverList.builder(
                    itemCount: tabs.length,
                    itemBuilder: (context, index) {
                      final tab = tabs[index];

                      return VerticalTab(
                        tabId: tab.id,
                        tabTitle: tab.title,
                      );
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: EmptyTab(),
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
