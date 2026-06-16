import 'package:flutter/material.dart';
import 'package:multichoice/app/view/theme/app_theme.dart';
import 'package:theme/theme.dart';
import 'package:ui_kit/ui_kit.dart';

const _colorNames = [
  'primary',
  'primaryLight',
  'secondary',
  'secondaryLight',
  'ternary',
  'foreground',
  'background',
  'white',
  'black',
  'error',
  'success',
  'enabled',
  'disabled',
  'filledButtonBackground',
  'filledButtonForeground',
  'outlinedButtonForeground',
  'outlinedButtonBorder',
  'textButtonForeground',
  'textButtonBackground',
  'scaffoldBackground',
  'cardBackground',
  'modalBackground',
  'appBarBackground',
  'textPrimary',
  'textSecondary',
  'textTertiary',
  'iconColor',
  'linkColor',
  'accent',
];

class AppColorsContent extends StatelessWidget {
  const AppColorsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColorSection(
            title: 'Light Theme',
            colors: AppTheme.lightAppColors,
          ),
          gap24,
          ColorSection(
            title: 'Dark Theme',
            colors: AppTheme.darkAppColors,
          ),
        ],
      ),
    );
  }
}

class ColorSection extends StatelessWidget {
  const ColorSection({
    required this.title,
    required this.colors,
    super.key,
  });

  final String title;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          gap12,
          LayoutBuilder(
            builder: (context, constraints) {
              const columns = 4;
              final itemSize =
                  (constraints.maxWidth - (columns - 1) * 8) / columns;

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _colorNames.map((name) {
                  final color = _colorByName(colors, name);

                  return SizedBox(
                    width: itemSize,
                    height: itemSize,
                    child: ColorSwatch(
                      name: name,
                      color: color,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Color? _colorByName(AppColorsExtension c, String name) {
    return switch (name) {
      'primary' => c.primary,
      'primaryLight' => c.primaryLight,
      'secondary' => c.secondary,
      'secondaryLight' => c.secondaryLight,
      'ternary' => c.ternary,
      'foreground' => c.foreground,
      'background' => c.background,
      'white' => c.white,
      'black' => c.black,
      'error' => c.error,
      'success' => c.success,
      'enabled' => c.enabled,
      'disabled' => c.disabled,
      'filledButtonBackground' => c.filledButtonBackground,
      'filledButtonForeground' => c.filledButtonForeground,
      'outlinedButtonForeground' => c.outlinedButtonForeground,
      'outlinedButtonBorder' => c.outlinedButtonBorder,
      'textButtonForeground' => c.textButtonForeground,
      'textButtonBackground' => c.textButtonBackground,
      'scaffoldBackground' => c.scaffoldBackground,
      'cardBackground' => c.cardBackground,
      'modalBackground' => c.modalBackground,
      'appBarBackground' => c.appBarBackground,
      'textPrimary' => c.textPrimary,
      'textSecondary' => c.textSecondary,
      'textTertiary' => c.textTertiary,
      'iconColor' => c.iconColor,
      'linkColor' => c.linkColor,
      'accent' => c.accent,
      _ => null,
    };
  }
}

class ColorSwatch extends StatelessWidget {
  const ColorSwatch({
    required this.name,
    required this.color,
    super.key,
  });

  final String name;
  final Color? color;

  /// Inserts zero-width spaces so camelCase names can wrap (e.g. secondaryLight).
  static String _addBreakOpportunities(String text) {
    return text.replaceAllMapped(
      RegExp('([a-z])([A-Z])'),
      (m) => '${m[1]}\u200B${m[2]}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall;
    final labelColor = color != null ? _contrastColor(color!) : Colors.grey;
    final displayText = color != null
        ? _addBreakOpportunities(name)
        : '${_addBreakOpportunities(name)}\n(null)';

    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        border: Border.all(
          color: color != null
              ? Colors.black.withValues(alpha: 0.2)
              : Colors.grey,
          width: color != null ? 1 : 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      padding: allPadding4,
      child: Center(
        child: Text(
          displayText,
          style: labelStyle?.copyWith(
            color: labelColor,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ),
    );
  }

  Color _contrastColor(Color bg) {
    final luminance = bg.computeLuminance();

    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
