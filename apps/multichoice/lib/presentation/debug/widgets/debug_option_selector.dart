import 'package:flutter/material.dart';
import 'package:multichoice/i18n/strings.g.dart';

enum DebugView { debugTools, featureFlags, appColors, appTextThemes }

class DebugOptionSelector extends StatelessWidget {
  const DebugOptionSelector({
    required this.selectedView,
    required this.onSelect,
    super.key,
  });

  final DebugView selectedView;
  final void Function(DebugView) onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _OptionChip(
          label: 'Debug Tools',
          isSelected: selectedView == DebugView.debugTools,
          onTap: () => onSelect(DebugView.debugTools),
        ),
        _OptionChip(
          label: context.t.debug.featureFlagsTab,
          isSelected: selectedView == DebugView.featureFlags,
          onTap: () => onSelect(DebugView.featureFlags),
        ),
        _OptionChip(
          label: 'App Colors',
          isSelected: selectedView == DebugView.appColors,
          onTap: () => onSelect(DebugView.appColors),
        ),
        _OptionChip(
          label: 'App Text Themes',
          isSelected: selectedView == DebugView.appTextThemes,
          onTap: () => onSelect(DebugView.appTextThemes),
        ),
      ],
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
    );
  }
}
