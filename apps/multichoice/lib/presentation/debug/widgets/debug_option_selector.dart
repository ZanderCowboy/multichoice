import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

enum DebugView { debugTools, appColors }

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
    return Row(
      children: [
        _OptionChip(
          label: 'Debug Tools',
          isSelected: selectedView == DebugView.debugTools,
          onTap: () => onSelect(DebugView.debugTools),
        ),
        gap12,
        _OptionChip(
          label: 'App Colors',
          isSelected: selectedView == DebugView.appColors,
          onTap: () => onSelect(DebugView.appColors),
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
