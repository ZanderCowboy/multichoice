import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:multichoice/app_router.gr.dart';
import 'package:multichoice/application/export_application.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/models/enums/menu_items.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';

part 'entry_card.dart';

class Cards extends StatelessWidget {
  const Cards({super.key});

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

                  return EntryCard(
                    tabId: state.tab.id,
                    entryId: entry.id,
                    title: entry.title,
                    subtitle: entry.subtitle,
                  );
                },
              ),
              SliverToBoxAdapter(
                child: EmptyEntry(tabId: state.tab.id),
              ),
            ],
          ),
        );
      },
    );
  }
}
