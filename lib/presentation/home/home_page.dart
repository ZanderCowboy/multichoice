import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/application/export_application.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/domain/entry/models/entry.dart';
import 'package:multichoice/domain/tabs/models/tabs.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:multichoice/presentation/home/widgets/add_entry_card.dart';
import 'package:multichoice/presentation/home/widgets/empty_tab_add_card.dart';
import 'package:multichoice/presentation/home/widgets/entry_cards.dart';
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
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final tabs = state.tabs;

        return Padding(
          padding: allPadding24,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height / 1.375,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: CustomScrollBehaviour(),
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: tabs.length + 1,
                      itemBuilder: (context, index) {
                        if (index == tabs.length) {
                          return const EmptyTab();
                        } else {
                          final tab = tabs[index];

                          return GestureDetector(
                            onLongPress: () {
                              CustomDialog.show(
                                context: context,
                                title: Text('Delete ${tab.title}'),
                                content: const SizedBox(
                                  height: 20,
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      gap10,
                                      ElevatedButton(
                                        onPressed: () {
                                          context.read<HomeBloc>().add(
                                                HomeEvent
                                                    .onLongPressedDeleteTab(
                                                  tab.id,
                                                ),
                                              );
                                          if (Navigator.canPop(context)) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                            child: VerticalTab(
                              tabId: tab.id,
                              tabTitle: tab.title,
                              tabSubtitle: tab.subtitle,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
