part of 'export.dart';

class HorizontalVerticalLayoutButton extends StatelessWidget {
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
      activeThumbColor: context.theme.appColors.secondary,
      inactiveThumbColor: context.theme.appColors.secondary,
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
        await coreSl<IAnalyticsService>().logEvent(
          UiActionEventData(
            page: AnalyticsPage.settings,
            button: AnalyticsButton.layout,
            action: AnalyticsAction.tap,
            source: value ? 'vertical_layout' : 'horizontal_layout',
          ),
        );
        await appLayout.setLayoutVertical(isVertical: value);
      },
    );
  }
}
