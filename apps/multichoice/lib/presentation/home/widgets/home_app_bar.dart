import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/app/engine/static_keys.dart';
import 'package:multichoice/app/engine/tooltip_enums.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:multichoice/presentation/registration/login_modal.dart';
import 'package:provider/provider.dart';
import 'package:ui_kit/ui_kit.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Consumer<AuthNotifier>(
          builder: (context, authNotifier, _) {
            final isLoggedIn = authNotifier.isUserLoggedIn;

            return AppBar(
              title: const Text('Multichoice'),
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
                if (isLoggedIn)
                  IconButton(
                    onPressed: () async {
                      await context.router.push(
                        const ProfilePageRoute(),
                      );
                    },
                    tooltip: 'Profile',
                    icon: const Icon(Icons.person_outline),
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    ),
                  )
                else
                  SizedBox(
                    height: 32,
                    width: 72,
                    child: TextButton(
                      onPressed: () async {
                        showLoginModal(context);
                      },
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.zero,
                        ),
                      ),
                      child: const Text('Sign In'),
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
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
