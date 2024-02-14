import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/application/export_application.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:multichoice/presentation/home/widgets/entry_cards.dart';
import 'package:multichoice/presentation/shared/widgets/add_cards/_base.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';

part 'widgets/vertical_tab.dart';
part 'widgets/entry_card.dart';
part 'widgets/empty_tab.dart';
part 'widgets/empty_entry.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => coreSl<HomeBloc>()..add(const HomeEvent.onGetTabs()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Multichoice'),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
        ),
        body: _HomePage(),
      ),
    );
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
        final tabs = state.tabs;

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

                    return BlocProvider(
                      create: (_) => coreSl<EntryBloc>()
                        ..add(EntryEvent.onGetEntryCards(tab.id)),
                      child: VerticalTab(
                        tabId: tab.id,
                        tabTitle: tab.title,
                      ),
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
