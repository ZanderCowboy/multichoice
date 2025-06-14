import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/presentation/search/search_result_card.dart';
import 'package:ui_kit/ui_kit.dart';

part 'widgets/_body_text.dart';
part 'widgets/_search_bar.dart';

@RoutePage()
class SearchPage extends StatelessWidget {
  const SearchPage({
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final void Function(SearchResult? result) onTap;
  final Future<void> Function(SearchResult? result) onEdit;
  final Future<void> Function(SearchResult? result) onDelete;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => coreSl<SearchBloc>(),
      child: _SearchView(
        onTap: onTap,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView({
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final void Function(SearchResult? result) onTap;
  final Future<void> Function(SearchResult? result) onEdit;
  final Future<void> Function(SearchResult? result) onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
        title: const _SearchBar(),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (_, state) {
          if (state.isLoading) {
            return CircularLoader.small();
          }

          if (state.errorMessage != null) {
            return Center(
              child: Text(
                state.errorMessage!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            );
          }

          if (state.results.isEmpty) {
            return const _BodyText();
          }

          return ListView.builder(
            padding: allPadding16,
            itemCount: state.results.length,
            itemBuilder: (_, index) {
              final result = state.results[index];
              final isTab = result.isTab;
              final item = result.item;
              final title =
                  isTab ? (item as TabsDTO).title : (item as EntryDTO).title;
              final subtitle = isTab
                  ? (item as TabsDTO).subtitle
                  : (item as EntryDTO).subtitle;
              return SearchResultCard(
                title: title,
                subtitle: subtitle,
                onTap: () {
                  onTap(result);
                  Future.delayed(const Duration(milliseconds: 100), () {})
                      .whenComplete(() {
                    if (context.mounted) context.router.pop();
                  });
                },
                onEdit: () async {
                  await onEdit(result);
                  if (context.mounted) {
                    context
                        .read<SearchBloc>()
                        .add(SearchEvent.search(state.query));
                  }
                },
                onDelete: () async {
                  await onDelete(result);
                  if (context.mounted) {
                    context.read<SearchBloc>().add(const SearchEvent.refresh());
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
