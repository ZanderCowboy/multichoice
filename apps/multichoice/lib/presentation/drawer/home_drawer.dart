import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/drawer/widgets/export.dart';

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
          const DrawerHeaderSection(),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: const [
                AppearanceSection(),
                Divider(height: 32),
                DataSection(),
                Divider(height: 32),
                MoreSection(),
              ],
            ),
          ),
          const AppVersion(),
        ],
      ),
    );
  }
}
