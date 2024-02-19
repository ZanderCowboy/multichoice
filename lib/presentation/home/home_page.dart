import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/application/export_application.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:multichoice/presentation/home/widgets/entry_cards.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';
import 'package:multichoice/utils/extensions/theme_getter.dart';
import 'package:multichoice/utils/theme_extension/app_theme.dart';
// import 'package:shared_preferences/shared_preferences.dart' as prefs;

part 'widgets/vertical_tab.dart';
part 'widgets/entry_card.dart';
part 'widgets/empty_tab.dart';
part 'widgets/empty_entry.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    // this.preferences,
    super.key,
  });

  // final prefs.SharedPreferences? preferences;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => coreSl<HomeBloc>()
        ..add(const HomeEvent.onGetTabs())
        ..add(const HomeEvent.onGetAllEntryCards()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // final themeMode = context.read<AppTheme>().themeMode;
          // final Object? theme = preferences?.getString('theme');

          return Scaffold(
            appBar: AppBar(
              title: const Text('Multichoice'),
              centerTitle: true,
              // backgroundColor: Colors.lightBlue,
              actions: [
                // prefs.getBool('')
                // if (theme == ThemeMode.light.toString())
                //   IconButton(
                //     onPressed: () async {
                //       _darkMode(context);
                //       await preferences?.setString('theme', 'dart');
                //     },
                //     icon: const Icon(Icons.dark_mode_outlined),
                //   )
                // else
                //   IconButton(
                //     onPressed: () {
                //       _lightMode(context);
                //       preferences?.setString('theme', 'light');
                //     },
                //     icon: const Icon(Icons.light_mode_outlined),
                //   ),
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
            body: _HomePage(),
          );
        },
      ),
    );
  }

  // void _lightMode(BuildContext context) {
  //   context.read<AppTheme>().themeMode = ThemeMode.light;
  // }

  // void _darkMode(BuildContext context) {
  //   context.read<AppTheme>().themeMode = ThemeMode.dark;
  // }
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

        return Padding(
          padding: allPadding12,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height / 1.375,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              scrollBehavior: CustomScrollBehaviour(),
              slivers: [
                SliverList.builder(
                  itemCount: tabs.length,
                  itemBuilder: (context, index) {
                    //! Idea: Isn't it possible to pass a tab instance back to the bloc and access it that way, instead of passing it in the UI
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
        );
      },
    );
  }
}
