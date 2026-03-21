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
            style: AppTypography.titleSmall.copyWith(
              color: context.theme.appColors.textSecondary ??
                  context.theme.appColors.textTertiary,
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
