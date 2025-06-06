import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/theme/app_theme.dart';
import 'package:multichoice/app/view/theme/app_typography.dart';
import 'package:multichoice/constants/export.dart';
import 'package:multichoice/generated/assets.gen.dart';
import 'package:multichoice/utils/custom_dialog.dart';
import 'package:multichoice/utils/product_tour/tour_widget_wrapper.dart';

part 'widgets/_light_dark_mode_button.dart';
part 'widgets/_app_version.dart';
part 'widgets/_drawer_header_section.dart';
part 'widgets/_appearance_section.dart';
part 'widgets/_data_section.dart';
part 'widgets/_more_section.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width,
      backgroundColor: context.theme.appColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _DrawerHeaderSection(),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: const [
                _AppearanceSection(),
                Divider(height: 32),
                _DataSection(),
                Divider(height: 32),
                _MoreSection(),
              ],
            ),
          ),
          const _AppVersion(),
        ],
      ),
    );
  }
}
