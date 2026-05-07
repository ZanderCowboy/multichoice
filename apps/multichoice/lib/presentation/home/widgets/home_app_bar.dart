import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/static_keys.dart';
import 'package:multichoice/app/engine/tooltip_enums.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/home/widgets/edit_mode_button.dart';
import 'package:multichoice/presentation/home/widgets/profile_button.dart';
import 'package:multichoice/presentation/home/widgets/search_button.dart';
import 'package:ui_kit/ui_kit.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return AppBar(
          title: Text(context.t.appTitle),
          actions: [
            const EditModeButton(),
            AnimatedOpacity(
              opacity: state.isEditMode ? 0.35 : 1,
              duration: const Duration(milliseconds: 180),
              child: IgnorePointer(
                ignoring: state.isEditMode,
                child: const SearchButton(),
              ),
            ),
            AnimatedOpacity(
              opacity: state.isEditMode ? 0.35 : 1,
              duration: const Duration(milliseconds: 180),
              child: IgnorePointer(
                ignoring: state.isEditMode,
                child: const ProfileButton(),
              ),
            ),
            gap12,
          ],
          leading: AnimatedOpacity(
            opacity: state.isEditMode ? 0.35 : 1,
            duration: const Duration(milliseconds: 180),
            child: IgnorePointer(
              ignoring: state.isEditMode,
              child: IconButton(
                onPressed: () async {
                  await coreSl<IAnalyticsService>().logEvent(
                    const UiActionEventData(
                      page: AnalyticsPage.home,
                      button: AnalyticsButton.settings,
                      action: AnalyticsAction.open,
                    ),
                  );
                  scaffoldKey.currentState?.openDrawer();
                },
                tooltip: TooltipEnums.settings.tooltip,
                icon: const Icon(Icons.settings_outlined),
              ),
            ),
          ),
        );
      },
    );
  }
}
