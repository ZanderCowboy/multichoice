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
        final menuIconColor = appColors.textPrimary;

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
                color: menuIconColor,
              ),
              gap8,
              Text(label, style: menuTextStyle),
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
                  title: RichText(
                    text: TextSpan(
                      text: 'Delete all entries of ',
                      style: DefaultTextStyle.of(
                        context,
                      ).style.copyWith(fontSize: 24),
                      children: [
                        TextSpan(
                          text: tab.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '?',
                          style: DefaultTextStyle.of(
                            context,
                          ).style.copyWith(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to delete all the entries of ${tab.title}?',
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                          HomeEvent.onPressedDeleteAllEntries(tab.id),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete Entries'),
                    ),
                  ],
                );
              case MenuItems.delete:
                deleteModal(
                  context: context,
                  title: tab.title,
                  content: Text(
                    "Are you sure you want to delete ${tab.title} and all it's entries?",
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
                label: MenuItems.edit.name,
              ),
            ),
            PopupMenuItem<MenuItems>(
              value: MenuItems.deleteEntries,
              enabled: tab.entries.isNotEmpty,
              textStyle: menuTextStyle,
              child: buildMenuItem(
                icon: Icons.delete_sweep_outlined,
                label: MenuItems.deleteEntries.name,
              ),
            ),
            PopupMenuItem<MenuItems>(
              value: MenuItems.delete,
              textStyle: menuTextStyle,
              child: buildMenuItem(
                icon: Icons.delete_outline,
                label: MenuItems.delete.name,
              ),
            ),
          ],
          icon: Icon(
            Icons.more_vert_outlined,
            color: appColors.textTertiary,
          ),
          color: appColors.scaffoldBackground,
          padding: zeroPadding,
        );
      },
    );
  }
}
