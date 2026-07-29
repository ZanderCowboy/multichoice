part of '../home_page.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    required this.tab,
    super.key,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final appColors = context.theme.appColors;
        final menuTextStyle = Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: appColors.textPrimary);

        Widget buildMenuItem({
          required IconData icon,
          required String label,
        }) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: appColors.textPrimary,
              ),
              gap8,
              Text(
                label,
                style: context.appTextTheme.bodyMedium?.copyWith(
                  color: appColors.textPrimary,
                ),
              ),
            ],
          );
        }

        return PopupMenuButton<MenuItems>(
          onSelected: (item) async {
            switch (item) {
              case MenuItems.edit:
                context.read<HomeBloc>().add(HomeEvent.onUpdateTabId(tab.id));
                await context.router.push(EditTabPageRoute(ctx: context));
              case MenuItems.deleteEntries:
                CustomDialog<AlertDialog>.show(
                  context: context,
                  title: Text.rich(
                    context.t.home.deleteAllEntriesTitle(
                      title: TextSpan(
                        text: tab.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  content: Text(
                    context.t.home.deleteAllEntriesContent(title: tab.title),
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(context.t.common.cancel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                          HomeEvent.onPressedDeleteAllEntries(tab.id),
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text(context.t.common.deleteEntries),
                    ),
                  ],
                );
              case MenuItems.delete:
                deleteModal(
                  context: context,
                  title: tab.title,
                  content: Text(
                    context.t.home.deleteTabAndEntriesContent(title: tab.title),
                  ),
                  onConfirm: () {
                    context.read<HomeBloc>().add(
                      HomeEvent.onLongPressedDeleteTab(
                        tab.id,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<MenuItems>(
              value: MenuItems.edit,
              textStyle: menuTextStyle,
              child: buildMenuItem(
                icon: Icons.edit_outlined,
                label: context.t.common.editTab,
              ),
            ),
            PopupMenuItem<MenuItems>(
              value: MenuItems.deleteEntries,
              enabled: tab.entries.isNotEmpty,
              textStyle: menuTextStyle,
              child: buildMenuItem(
                icon: Icons.delete_sweep_outlined,
                label: context.t.common.deleteEntries,
              ),
            ),
            PopupMenuItem<MenuItems>(
              value: MenuItems.delete,
              textStyle: menuTextStyle,
              child: buildMenuItem(
                icon: Icons.delete_outline,
                label: context.t.tooltips.deleteTab,
              ),
            ),
          ],
          icon: Icon(
            Icons.more_vert_outlined,
            color: appColors.ternary,
          ),
          color: appColors.scaffoldBackground,
          padding: zeroPadding,
        );
      },
    );
  }
}
