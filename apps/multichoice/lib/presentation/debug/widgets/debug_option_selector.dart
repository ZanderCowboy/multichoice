import 'package:flutter/material.dart';

enum DebugView { debugTools, appColors, appTextThemes }

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
      spacing: 12,
      runSpacing: 8,
      children: [
        _OptionChip(
          label: 'Debug Tools',
          isSelected: selectedView == DebugView.debugTools,
          onTap: () => onSelect(DebugView.debugTools),
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
