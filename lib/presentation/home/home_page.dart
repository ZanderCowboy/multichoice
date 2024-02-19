import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:multichoice/application/export_application.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:multichoice/presentation/home/widgets/entry_cards.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
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
      create: (context) => coreSl<HomeBloc>()
        ..add(const HomeEvent.onGetTabs())
        ..add(const HomeEvent.onGetAllEntryCards()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Multichoice'),
              centerTitle: true,
              backgroundColor: Colors.lightBlue,
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
            body: _HomePage(),
          );
        },
      ),
    );
  }
}

class _HomePage extends HookWidget {
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
        final screenHeight = MediaQuery.sizeOf(context).height;
        final screenWidth = MediaQuery.sizeOf(context).width;

        return Padding(
          padding: allPadding12,
          child: SizedBox(
            height: screenHeight / 1.375,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              scrollBehavior: CustomScrollBehaviour(),
              slivers: [
                SliverToBoxAdapter(
                  child: ReorderableListView.builder(
                    scrollController: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length,
                    onReorder: (oldIndex, newIndex) {
                      context.read<HomeBloc>().add(
                            HomeEvent.onReorderTabs(oldIndex, newIndex),
                          );
                    },
                    itemBuilder: (context, index) {
                      //! Idea: Isn't it possible to pass a tab instance back to the bloc and access it that way, instead of passing it in the UI
                      final tab = tabs[index];

                      return ReorderableDragStartListener(
                        index: index,
                        key: ValueKey(tab.id),
                        child: Draggable<Widget>(
                          feedback: SizedBox(
                            height: screenHeight / 1.625,
                            width: screenWidth / 5,
                            child: MoveTab(
                              width: double.infinity,
                              child: Center(child: Text(tab.title)),
                            ),
                          ),
                          // TODO(ZanderCowboy): Look into why the size gets smaller
                          childWhenDragging: SizedBox(
                            height: screenHeight / 1.375,
                            width: screenWidth / 4,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: MoveTab(
                                width: double.infinity,
                                child: Center(child: Text(tab.title)),
                              ),
                            ),
                          ),
                          child: VerticalTab(
                            tabId: tab.id,
                            tabTitle: tab.title,
                          ),
                        ),
                      );
                    },
                  ),
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
