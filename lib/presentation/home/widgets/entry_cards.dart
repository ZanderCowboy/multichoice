import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/application/entry/entry_bloc.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';

class Cards extends StatelessWidget {
  const Cards({
    required this.tabId,
    super.key,
  });

  final String tabId;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return BlocProvider(
      create: (_) => coreSl<EntryBloc>()
        ..add(
          EntryEvent.onGetEntryCards(tabId),
        ),
      child: BlocBuilder<EntryBloc, EntryState>(
        builder: (context, state) {
          if (state.entry.tabId != tabId) {
            context.read<EntryBloc>().add(
                  EntryEvent.onGetEntryCards(tabId),
                );
          }

          final entriesInTab = state.entryCards ?? [];

          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          return Expanded(
            child: ScrollConfiguration(
              behavior: CustomScrollBehaviour(),
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.vertical,
                itemCount: entriesInTab.length + 1,
                itemBuilder: (context, index) {
                  if (index == entriesInTab.length) {
                    return EmptyEntry(tabId: tabId);
                  } else {
                    final entry = entriesInTab[index];

                    return EntryCard(
                      title: entry.title,
                      subtitle: entry.subtitle,
                      tabId: tabId,
                      entryId: entry.id,
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
