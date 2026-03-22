import 'package:flutter/material.dart';
import 'package:multichoice/app/view/theme/app_theme.dart';
import 'package:theme/theme.dart';
import 'package:ui_kit/ui_kit.dart';

const _textStyleNames = [
  'headingLarge',
  'headingMedium',
  'headingSmall',
  'titleLarge',
  'titleMedium',
  'titleSmall',
  'subtitleLarge',
  'subtitleMedium',
  'subtitleSmall',
  'bodyLarge',
  'bodyMedium',
  'bodySmall',
  'denseTitle',
  'denseSubtitle',
  'hyperlink',
];

class AppTextThemesContent extends StatelessWidget {
  const AppTextThemesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Theme(
            data: AppTheme.lightThemeData,
            child: _TextThemeSection(
              title: 'Light Theme',
              backgroundColor: AppTheme.lightAppColors.scaffoldBackground,
              appText: AppTheme.lightTextTheme,
            ),
          ),
          gap24,
          Theme(
            data: AppTheme.darkThemeData,
            child: _TextThemeSection(
              title: 'Dark Theme',
              backgroundColor: AppTheme.darkAppColors.scaffoldBackground,
              appText: AppTheme.darkTextTheme,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextThemeSection extends StatelessWidget {
  const _TextThemeSection({
    required this.title,
    required this.backgroundColor,
    required this.appText,
  });

  final String title;
  final Color? backgroundColor;
  final AppTextExtension appText;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? Colors.transparent,
      child: Padding(
        padding: allPadding12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            gap12,
            ..._textStyleNames.map((name) {
              final style = _styleByName(appText, name);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TextStylePreview(
                  name: name,
                  style: style,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  TextStyle? _styleByName(AppTextExtension t, String name) {
    return switch (name) {
      'headingLarge' => t.headingLarge,
      'headingMedium' => t.headingMedium,
      'headingSmall' => t.headingSmall,
      'titleLarge' => t.titleLarge,
      'titleMedium' => t.titleMedium,
      'titleSmall' => t.titleSmall,
      'subtitleLarge' => t.subtitleLarge,
      'subtitleMedium' => t.subtitleMedium,
      'subtitleSmall' => t.subtitleSmall,
      'bodyLarge' => t.bodyLarge,
      'bodyMedium' => t.bodyMedium,
      'bodySmall' => t.bodySmall,
      'denseTitle' => t.denseTitle,
      'denseSubtitle' => t.denseSubtitle,
      'hyperlink' => t.hyperlink,
      _ => null,
    };
  }
}

class _TextStylePreview extends StatelessWidget {
  const _TextStylePreview({
    required this.name,
    required this.style,
  });

  final String name;
  final TextStyle? style;

  /// Inserts zero-width spaces so camelCase names can wrap.
  static String _addBreakOpportunities(String text) {
    return text.replaceAllMapped(
      RegExp('([a-z])([A-Z])'),
      (m) => '${m[1]}\u200B${m[2]}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall;
    final displayName = _addBreakOpportunities(name);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          style: labelStyle,
        ),
        gap4,
        Text(
          style != null
              ? 'Aa Bb Cc 0123456789 — The quick brown fox'
              : '$displayName (null)',
          style: style,
        ),
      ],
    );
  }
}
