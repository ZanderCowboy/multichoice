import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:multichoice/application/export_application.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:multichoice/models/enums/menu_items.dart';
import 'package:multichoice/presentation/home/widgets/entry_cards.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';

part 'widgets/empty_entry.dart';
part 'widgets/empty_tab.dart';
part 'widgets/entry_card.dart';
part 'widgets/menu_items.dart';
part 'widgets/vertical_tab.dart';

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

        final tabs = state.tabs;
        final screenHeight = MediaQuery.sizeOf(context).height;

        return Center(
          child: Padding(
            padding: allPadding24,
            child: SizedBox(
              height: screenHeight,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                scrollBehavior: CustomScrollBehaviour(),
                slivers: [
                  SliverList.builder(
                    itemCount: tabs.length,
                    itemBuilder: (context, index) {
                      final tab = tabs[index];

                      return VerticalTab(tabId: tab.id);
                    },
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width / 6,
                      child: const EmptyTab(),
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
