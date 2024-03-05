import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/application/home/home_bloc.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:multichoice/models/dto/export_dto.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';

part 'widgets/entry_card.dart';
part 'widgets/cards.dart';
part 'widgets/new_entry.dart';
part 'widgets/new_tab.dart';
part 'widgets/vertical_tab.dart';

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

        return Padding(
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
        );
      },
    );
  }
}
