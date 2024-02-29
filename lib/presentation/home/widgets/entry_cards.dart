import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/application/export_application.dart';
import 'package:multichoice/constants/spacing_constants.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';

class Cards extends StatelessWidget {
  const Cards({
    required this.tabId,
    super.key,
  });

  final int tabId;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        final entriesInTab = state.entryCards ?? [];

        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        return Expanded(
          child: CustomScrollView(
            controller: scrollController,
            scrollBehavior: CustomScrollBehaviour(),
            slivers: [
              SliverList.builder(
                itemCount: entriesInTab.length,
                itemBuilder: (context, index) {
                  final entry = entriesInTab[index];

                  return GestureDetector(
                    onLongPress: () {
                      CustomDialog<Widget>.show(
                        context: context,
                        title: Text('Delete ${entry.title}'),
                        content: SizedBox(
                          height: 20,
                          child: Text(
                            "Are you sure you want to delete entry ${entry.title} and all it's content?",
                          ),
                        ),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              gap10,
                              ElevatedButton(
                                onPressed: () {
                                  context.read<HomeBloc>().add(
                                        HomeEvent.onLongPressedDeleteEntry(
                                          tabId,
                                          entry.id,
                                        ),
                                      );
                                  if (Navigator.canPop(context)) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    child: EntryCard(
                      tabId: tabId,
                      entryId: entry.id,
                      title: entry.title,
                      subtitle: entry.subtitle,
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: EmptyEntry(tabId: tabId),
              ),
            ],
          ),
        );
      },
    );
  }
}
