part of '../details_page.dart';

class _DetailsListTile extends StatelessWidget {
  const _DetailsListTile({
    required this.title,
    this.subtitle,
    this.isEditing = false,
    this.controller,
    this.onChanged,
    this.labelText,
  });

  final String title;
  final String? subtitle;
  final bool isEditing;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: context.theme.appColors.secondary?.withValues(alpha: 0.1),
      contentPadding: horizontal16,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular12,
      ),
      title: !isEditing
          ? Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.theme.appColors.ternary,
              ),
            )
          : null,
      subtitle: isEditing
          ? TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                border: OutlineInputBorder(
                  borderRadius: borderCircular12,
                ),
                isDense: true,
              ),
              onChanged: onChanged,
            )
          : Text(
              subtitle ?? '',
              style: TextStyle(
                fontSize: 16,
                color: context.theme.appColors.ternary,
              ),
            ),
    );
  }
}
