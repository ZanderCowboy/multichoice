import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/analytics/analytics_page_tracker.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/layouts/export.dart';
import 'package:multichoice/presentation/drawer/home_drawer.dart';
import 'package:multichoice/presentation/home/widgets/app_bar.dart';
import 'package:multichoice/presentation/home/widgets/import_data_banner.dart';
import 'package:multichoice/presentation/home/widgets/welcome_modal_handler.dart';
import 'package:multichoice/presentation/registration/login_modal.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';
import 'package:multichoice/presentation/shared/widgets/forms/reusable_form.dart';
import 'package:multichoice/presentation/shared/widgets/modals/delete_modal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:ui_kit/ui_kit.dart';

part 'utils/_check_and_request_permissions.dart';
part 'utils/_trigger_edit_mode_haptic.dart';
part 'widgets/collection_tab.dart';
part 'widgets/edit_mode_button.dart';
part 'widgets/entry_card.dart';
part 'widgets/menu_widget.dart';
part 'widgets/new_entry.dart';
part 'widgets/new_tab.dart';
part 'widgets/search_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeModalHandler(
      builder: (_) => const _HomePage(),
      onSkipTour: () async {
        context.read<ProductBloc>().add(const ProductEvent.skipTour());
      },
      onFollowTutorial: () async {
        await context.router.push(
          TutorialPageRoute(
            onCallback: () {
              context.read<HomeBloc>().add(const HomeEvent.onGetTabs());
            },
          ),
        );
      },
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnalyticsPageTracker(
      page: AnalyticsPage.home,
      // this ShowCaseWidget is here to fix an issue where it complains
      // about ShowCaseView context not being available
      // ignore: deprecated_member_use
      child: ShowCaseWidget(
        builder: (context) => BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
              previous.isEditMode != current.isEditMode,
          builder: (context, state) {
            return PopScope(
              canPop: !state.isEditMode && !_isDrawerOpen,
              onPopInvokedWithResult: (didPop, _) {
                if (didPop) return;

                if (_isDrawerOpen) {
                  Navigator.of(context).pop();
                  return;
                }

                if (state.isEditMode) {
                  context.read<HomeBloc>().add(
                    const HomeEvent.onToggleEditMode(),
                  );
                }
              },
              child: Scaffold(
                key: scaffoldKey,
                onDrawerChanged: (isOpened) {
                  if (_isDrawerOpen == isOpened) return;
                  setState(() {
                    _isDrawerOpen = isOpened;
                  });
                },
                appBar: const HomeAppBar(),
                drawer: const HomeDrawer(),
                body: const Column(
                  children: [
                    ImportDataBanner(),
                    Expanded(
                      child: SafeArea(
                        child: HomeLayout(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
