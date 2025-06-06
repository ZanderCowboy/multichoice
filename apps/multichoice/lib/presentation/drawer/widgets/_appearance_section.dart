part of '../home_drawer.dart';

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context) {
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
        const _LightDarkModeButton(),
        SwitchListTile(
          key: context.keys.layoutSwitch,
          title: const Text('Horizontal / Vertical Layout'),
          value: context.watch<AppLayout>().isLayoutVertical,
          onChanged: (value) async {
            await context
                .read<AppLayout>()
                .setLayoutVertical(isVertical: value);
          },
        ),
      ],
    );
  }
}
