part of '../home_page.dart';

PreferredSizeWidget _appBar(
  BuildContext context,
  GlobalKey<ScaffoldState> scaffoldKey,
) {
  return AppBar(
    title: const Text('Multichoice'),
    actions: [
      IconButton(
        onPressed: () => coreSl<ShowcaseManager>().startShowcase(context),
        icon: const Icon(
          Icons.play_arrow,
        ),
      ),
      Showcase(
        key: coreSl<ShowcaseManager>().openSettings,
        title: 'Search',
        description: 'Search for tabs or entries',
        onBarrierClick: () => debugPrint('Barrier clicked'),
        disposeOnTap: true,
        onTargetClick: () {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text('Search has not been implemented yet.'),
              ),
            );
          coreSl<ShowcaseManager>().startSettingsShowcase(context);
        },
        child: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Search has not been implemented yet.'),
                ),
              );
          },
          tooltip: TooltipEnums.search.tooltip,
          icon: const Icon(Icons.search_outlined),
        ),
      ),
    ],
    leading: Showcase(
      key: coreSl<ShowcaseManager>().openSettings,
      title: 'Settings',
      description: 'Open the settings drawer',
      onBarrierClick: () => debugPrint('Barrier clicked'),
      disposeOnTap: true,
      onTargetClick: () {
        scaffoldKey.currentState?.openDrawer();
        coreSl<ShowcaseManager>().startInfoShowcase(context);
      },
      child: IconButton(
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
        tooltip: TooltipEnums.settings.tooltip,
        icon: const Icon(Icons.settings_outlined),
      ),
    ),
  );
}
