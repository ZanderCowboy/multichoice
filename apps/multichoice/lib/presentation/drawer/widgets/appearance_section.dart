part of 'export.dart';

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: horizontal16 + vertical8,
          child: Text(
            'Appearance',
            style: context.appTextTheme.titleSmall!.copyWith(
              letterSpacing: 1.1,
            ),
          ),
        ),
        const LightDarkModeButton(),
        const HorizontalVerticalLayoutButton(),
      ],
    );
  }
}
