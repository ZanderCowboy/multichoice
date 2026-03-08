import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/search/search_result_card.dart';
import 'package:ui_kit/ui_kit.dart';

part 'widgets/_body_text.dart';
part 'widgets/_search_bar.dart';
part 'widgets/_search_body.dart';

@RoutePage()
class SearchPage extends StatelessWidget {
  const SearchPage({
    required this.onEdit,
    required this.onDelete,
    required this.onBack,
    super.key,
  });

  final Future<void> Function(SearchResult? result) onEdit;
  final Future<void> Function(SearchResult? result) onDelete;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => coreSl<SearchBloc>(),
      child: _SearchView(
        onEdit: onEdit,
        onDelete: onDelete,
        onBack: onBack,
      ),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView({
    required this.onEdit,
    required this.onDelete,
    required this.onBack,
  });

  final Future<void> Function(SearchResult? result) onEdit;
  final Future<void> Function(SearchResult? result) onDelete;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: const _SearchBar(),
      ),
      body: SafeArea(
        child: BlocBuilder<SearchBloc, SearchState>(
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

            return _SearchBody(
              onEdit: onEdit,
              onDelete: onDelete,
              onBack: onBack,
            );
          },
        ),
      ),
    );
  }
}
