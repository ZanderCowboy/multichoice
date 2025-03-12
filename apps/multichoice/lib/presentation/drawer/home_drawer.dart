import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/app/export_app.dart';
import 'package:multichoice/app/view/layout/app_layout.dart';
import 'package:multichoice/app/view/theme/app_theme.dart';
import 'package:multichoice/constants/export_constants.dart';
import 'package:multichoice/generated/assets.gen.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'widgets/_light_dark_mode_button.dart';
part 'widgets/_app_version.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Drawer(
          width: MediaQuery.sizeOf(context).width,
          backgroundColor: context.theme.appColors.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DrawerHeader(
                padding: allPadding12,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Settings',
                        style: context.theme.appTextTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      tooltip: TooltipEnums.close.tooltip,
                      icon: const Icon(
                        Icons.close_outlined,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const _LightDarkModeButton(),
                    ListTile(
                      title: const Text('Horizontal/Vertical Layout'),
                      trailing: Switch(
                        value: context.watch<AppLayout>().appLayout,
                        onChanged: (value) {
                          context.read<AppLayout>().appLayout = value;
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Delete All Data'),
                      trailing: IconButton(
                        onPressed: state.tabs != null && state.tabs!.isNotEmpty
                            ? () {
                                CustomDialog<AlertDialog>.show(
                                  context: context,
                                  title: const Text(
                                    'Delete all tabs and entries?',
                                  ),
                                  content: const Text(
                                    'Are you sure you want to delete all tabs and their entries?',
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('No, cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<HomeBloc>().add(
                                              const HomeEvent
                                                  .onPressedDeleteAll(),
                                            );
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Yes, delete'),
                                    ),
                                  ],
                                );
                              }
                            : null,
                        tooltip: TooltipEnums.deleteAllData.tooltip,
                        icon: state.tabs == null || state.tabs!.isEmpty
                            ? Icon(
                                Icons.delete_sweep_outlined,
                                color: context.theme.appColors.disabled,
                              )
                            : Icon(
                                Icons.delete_sweep_rounded,
                                color: context.theme.appColors.enabled,
                              ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Import / Export Data'),
                      trailing: IconButton(
                        onPressed: () => context.router.push(
                          const DataTransferScreenRoute(),
                        ),
                        tooltip: TooltipEnums.importExport.tooltip,
                        icon: const Icon(
                          Icons.import_export_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const _AppVersion(),
            ],
          ),
        );
      },
    );
  }
}
