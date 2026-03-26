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
      title: Text(
        'Horizontal / Vertical Layout',
        style: context.appTextTheme.denseTitle,
      ),
      value: appLayout.isLayoutVertical,
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return context.appColorsTheme.primaryLight;
        }
        return context.appColorsTheme.primaryLight;
      }),
      activeThumbColor: context.theme.appColors.accent,
      inactiveThumbColor: context.theme.appColors.accent,
      thumbIcon: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Icon(
            Icons.view_column,
            color: context.appColorsTheme.primary,
          );
        }

        return Icon(
          Icons.unfold_more,
          color: context.appColorsTheme.primary,
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
