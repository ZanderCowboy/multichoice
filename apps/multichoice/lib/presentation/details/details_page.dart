import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:ui_kit/ui_kit.dart';

part 'widgets/_app_bar.dart';
part 'widgets/_children_grid_list.dart';
part 'widgets/_children_list_view.dart';
part 'widgets/_details_list_tile.dart';
part 'widgets/_details_section.dart';
part 'widgets/_editing_overlay.dart';
part 'widgets/_parent_tab.dart';
part 'widgets/_result_list_tile.dart';

@RoutePage()
class DetailsPage extends StatelessWidget {
  const DetailsPage({
    required this.result,
    required this.onBack,
    super.key,
  });

  final SearchResult result;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => coreSl<DetailsBloc>()
        ..add(
          DetailsEvent.onPopulate(result),
        ),
      child: SafeArea(
        child: Scaffold(
          appBar: _AppBar(
            onBack: onBack,
          ),
          body: const _DetailsView(),
        ),
      ),
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularLoader.medium());
        }

        return Stack(
          children: [
            CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _DetailsSection(),
                      Divider(
                        thickness: 1.5,
                        color: context.theme.appColors.primary,
                      ),
                    ],
                  ),
                ),
                if (state.children != null) ...[
                  SliverToBoxAdapter(
                    child: _titleWidget(context, 'Items'),
                  ),
                  // TODO: Add logic to switch between grid and list view
                  const _ChildrenListView(),
                ],
                if (state.parent != null) ...[
                  SliverToBoxAdapter(
                    child: _titleWidget(context, 'Collection'),
                  ),
                  const SliverToBoxAdapter(child: _ParentTab()),
                ],
                if (state.isEditingMode) const SliverToBoxAdapter(child: gap80),
                const SliverToBoxAdapter(child: gap56),
              ],
            ),
            if (state.isEditingMode) ...[
              const _EditingOverlay(),
            ],
          ],
        );
      },
    );
  }

  Widget _titleWidget(
    BuildContext context,
    String value,
  ) {
    return Padding(
      padding: left12,
      child: Text(
        value,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: context.theme.appColors.ternary,
        ),
      ),
    );
  }
}
