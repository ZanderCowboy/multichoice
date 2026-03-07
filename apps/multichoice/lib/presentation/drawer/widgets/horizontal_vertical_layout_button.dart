part of 'export.dart';

class HorizontalVerticalLayoutButton extends HookWidget {
  const HorizontalVerticalLayoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appLayout = context.watch<AppLayout>();

    if (!appLayout.isInitialized) {
      return CircularLoader.small();
    }

    return SwitchListTile(
      key: context.keys.layoutSwitch,
      title: const Text('Horizontal / Vertical Layout'),
      value: appLayout.isLayoutVertical,
      trackColor: WidgetStatePropertyAll(
        context.theme.appColors.primary,
      ),
      activeThumbColor: context.theme.appColors.secondary,
      inactiveThumbColor: context.theme.appColors.secondary,
      activeThumbImage: AssetImage(Assets.images.verticalMode.path),
      thumbIcon: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(
            Icons.view_column,
            color: Colors.white,
          );
        }

        return const Icon(
          Icons.unfold_more,
          color: Colors.white,
        );
      }),
      onChanged: (value) async {
        await appLayout.setLayoutVertical(isVertical: value);
      },
    );
  }
}
