part of 'export.dart';

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appLayout = context.watch<AppLayout>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: horizontal16 + vertical8,
          child: Text(
            'Appearance',
            style: AppTypography.titleSmall.copyWith(
              color: Colors.white70,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const LightDarkModeButton(),
        if (!appLayout.isInitialized)
          const Center(
            child: Padding(
              padding: allPadding16,
              child: CircularProgressIndicator(),
            ),
          )
        else
          SwitchListTile(
            key: context.keys.layoutSwitch,
            title: const Text('Horizontal / Vertical Layout'),
            value: appLayout.isLayoutVertical,
            onChanged: (value) async {
              await appLayout.setLayoutVertical(isVertical: value);
            },
          ),
      ],
    );
  }
}
